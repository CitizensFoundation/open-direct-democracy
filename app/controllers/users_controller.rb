# Copyright (C) 2008,2009 Róbert Viðar Bjarnason
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
class UsersController < ApplicationController
  layout "citizen"
  skip_before_filter :check_authentication, :only => [ :login, :logout, :eid_login ]
  skip_before_filter :check_authorization, :only => [ :login, :logout, :eid_login ]
  filter_parameter_logging :login_password, :password, :password_confirmation
  before_filter :redirect_to_ssl, :only => [:eid_login]

  def complete_login
    if xml_request?
      render :file => 'users/login.rxml', :layout => false, :use_full_path => true
    else
      if session[:intended_action]
        redirect_to :action => session[:intended_action],
                    :controller => session[:intended_controller],
                    :params => session[:params]
      else
        redirect_to :controller => "cases"
      end
    end
  end

  def login
    session[:user_id] = nil
    session[:user_email] = nil
    if request.post? and params[:odd_action]=="login"
      user = User.authenticate(params[:login_user][:login_email], params[:login_user][:login_password])
      if user
        info("user_id: #{user.id} authenticated")
        session[:user_id] = user.id
        session[:user_email] = user.email
        complete_login
      else
        warn("invalid e-mail/password")
        flash[:notice] = t(:invalid_login)
        xml_error("LoginError", flash[:notice], "") if xml_request?
      end
    elsif request.post? and params[:odd_action]=="create"
      @user = User.new(params[:user])
      if @user.save
        info("user_id: #{@user.id} created")
        session[:user_id] = @user.id
        session[:user_email] = @user.email
        complete_login
        #TODO: Validate the line below...
        @user = User.new
      else
        flash[:notice] = t(:invalid_registration)
        error("user_id: #{@user.id} couldn't be saved")
        if xml_request?
          full_error = ""
          for error in @user.errors
            full_error = "#{full_error}#{error[0].humanize} #{error[1]}\n\n"
          end
          xml_error("CreateError", full_error)
        end
      end
    elsif not request.post? and xml_request?
      xml_error("RedirectLogin", "You need to login")
    end
  end
 
  def eid_login
    subject = request.env["SSL_CLIENT_S_DN"]
    citizen_id = name = first_name = last_name = nil
    if subject
      subject.split("/").each do |entry|
        params = entry.split("=")
        if params.length==2 and (params[0]=="serialNumber" or params[0]=="oid.2.5.4.5")
          citizen_id = params[1]
        end
        if params.length==2 and params[0]=="CN"
          name = params[1]
        end
      end
      if citizen_id and name
        namep = name.split
        first_name = namep[0..namep.length-2].join(" ")
        last_name = namep[namep.length-1]
        end
      end
    end
    
    if citizen_id and first_name and last_name
      user = User.find_by_citizen_id(citizen_id)
      if user
        info("user_id: #{user.id} authenticated with electronic id")
        session[:user_id] = user.id
        session[:user_email] = user.email
        redirect_to :controller => "cases"
      else
        user = User.new
        user.citizen_id = citizen_id
        user.first_name = first_name
        user.last_name = last_name
        user.save(false)
        session[:user_id] = user.id
        session[:user_email] = user.email
        info("Created user #{user.full_name}")
        redirect_to :controller => "cases"
      end
    else
      error("Couldn't find or create user")
    end
  end

  def logout
    info("user_id: #{session[:user_id]} logout")
    reset_session
    session[:user_id] = nil
    redirect_to(:controller => "cases") unless xml_request?
  end

  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
