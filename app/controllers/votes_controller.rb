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
 
class VotesController < ApplicationController
  # GET /votes
  # GET /votes.xml
  def index
    @votes = Vote.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.xml
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.xml
  def new
    @vote = Vote.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.xml
  def create
    Vote.delete_all(["document_id = ? AND user_id = ?", params[:vote][:document_id], session[:user_id]])
    params[:vote][:user_id]=session[:user_id]
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if params[:vote][:agreed]==nil
        flash[:notice] = t(:you_need_to_select_either_in_support_or_against_when_you_vote)
        format.html { redirect_to(:controller => "documents", :action=>"show", :id => @vote.document_id)}
      elsif @vote.save
        flash[:notice] = 'Vote was successfully created.'
        format.html { redirect_to(:controller => "documents", :action=>"show", :id => @vote.document_id)}
        format.xml  { render :xml => @vote, :status => :created, :location => @vote }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.xml
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        flash[:notice] = 'Vote was successfully updated.'
        format.html { redirect_to(@vote) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.xml
  def destroy
    @vote = Vote.find(params[:id])
    document_id = @vote.document_id
    if @vote.user_id = session[:user_id]
      flash[:notice] = 'Vote was successfully removed.'
      @vote.destroy
    else
      flash[:notice] = 'You can only remove your own vote.'
    end
    respond_to do |format|
      format.html { document_id ? redirect_to(:controller => "documents", :action=>"show", :id => document_id) : redirect_to(votes_url) }
      format.xml  { head :ok }
    end
  end
end
