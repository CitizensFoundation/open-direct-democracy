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
 
class EmptyUser < ApplicationController # Mega hack, needed some methods from here
  def id
    -1
  end
  def name_with_initial_and_citizen_id
    t(:no_proxy_user_selected)
  end
end

class VoteProxiesController < ApplicationController
  layout "citizen"  

  # GET /vote_proxies
  # GET /vote_proxies.xml
  def index
    @vote_proxies = VoteProxy.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vote_proxies }
    end
  end

  # GET /vote_proxies/1
  # GET /vote_proxies/1.xml
  def show
    @vote_proxy = VoteProxy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vote_proxy }
    end
  end

  # GET /vote_proxies/new
  # GET /vote_proxies/new.xml
  def new
    @vote_proxy = VoteProxy.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vote_proxy }
    end
  end

  # GET /vote_proxies/1/edit
  def edit
    @vote_proxy = VoteProxy.find(params[:id])
  end

  # POST /vote_proxies
  # POST /vote_proxies.xml
  def create
    @vote_proxy = VoteProxy.new(params[:vote_proxy])

    respond_to do |format|
      if @vote_proxy.save
        flash[:notice] = 'VoteProxy was successfully created.'
        format.html { redirect_to(@vote_proxy) }
        format.xml  { render :xml => @vote_proxy, :status => :created, :location => @vote_proxy }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vote_proxy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vote_proxies/1
  # PUT /vote_proxies/1.xml
  def update
    @vote_proxy = VoteProxy.find(params[:id])

    respond_to do |format|
      if @vote_proxy.update_attributes(params[:vote_proxy])
        flash[:notice] = 'VoteProxy was successfully updated.'
        format.html { redirect_to(@vote_proxy) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vote_proxy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vote_proxies/1
  # DELETE /vote_proxies/1.xml
  def destroy
    @vote_proxy = VoteProxy.find(params[:id])
    @vote_proxy.destroy

    respond_to do |format|
      format.html { redirect_to(vote_proxies_url) }
      format.xml  { head :ok }
    end
  end
  
  def select_proxy_user
  end

  def manage_by_proxy_user #TODO: finish this feature
    unless require.post?
      @categories = Category.find(:all)
      if params[:proxy_user_email]
        @proxy_user = User.find_by_email(params[:proxy_user_email])
      elsif params[:proxy_user_citizen_id]
        @proxy_user = User.find_by_citizen_id(params[:proxy_user_citizen_id])
      end
      if @proxy_user
        @all_my_vote_proxies = VoteProxy.find(:all, :conditions => ["from_user_id = ?", session[:user_id]])
      else
        flash[:notice] = t(:could_not_find_proxy_user_email)
      end
    else
    end
  end

  def manage
    if request.post?
      VoteProxy.delete_all(["from_user_id = ?", session[:user_id]])
      for category in params[:categories]
        if category[1].to_i != -1
          to_user = User.find(category[1].to_i)
          if to_user
            vp = VoteProxy.new
            vp.from_user_id = session[:user_id]
            vp.to_user_id = to_user.id
            vp.category_id = category[0].to_i
            vp.save
          end
        end
      end
    end
    @categories = Category.find(:all)
    users = User.find(:all)
    @all_proxy_user_options = []
    @all_proxy_user_options << EmptyUser.new
    for user in users
      @all_proxy_user_options << user unless user.id == session[:user_id] or user.email=="admin"
    end
  end
end
