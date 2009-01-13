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

class CaseDiscussionsController < ApplicationController
  # GET /case_discussionss
  # GET /case_discussionss.xml
  def index
    @case_discussionss = CaseDiscussion.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @case_discussionss }
    end
  end

  # GET /case_discussionss/1
  # GET /case_discussionss/1.xml
  def show
    @case_discussions = CaseDiscussion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @case_discussions }
    end
  end

  # GET /case_discussionss/new
  # GET /case_discussionss/new.xml
  def new
    @case_discussions = CaseDiscussion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @case_discussions }
    end
  end

  # GET /case_discussionss/1/edit
  def edit
    @case_discussions = CaseDiscussion.find(params[:id])
  end

  # POST /case_discussionss
  # POST /case_discussionss.xml
  def create
    @case_discussions = CaseDiscussion.new(params[:case_discussions])

    respond_to do |format|
      if @case_discussions.save
        flash[:notice] = 'CaseDiscussion was successfully created.'
        format.html { redirect_to(@case_discussions) }
        format.xml  { render :xml => @case_discussions, :status => :created, :location => @case_discussions }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @case_discussions.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /case_discussionss/1
  # PUT /case_discussionss/1.xml
  def update
    @case_discussions = CaseDiscussion.find(params[:id])

    respond_to do |format|
      if @case_discussions.update_attributes(params[:case_discussions])
        flash[:notice] = 'CaseDiscussion was successfully updated.'
        format.html { redirect_to(@case_discussions) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @case_discussions.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /case_discussionss/1
  # DELETE /case_discussionss/1.xml
  def destroy
    @case_discussions = CaseDiscussion.find(params[:id])
    @case_discussions.destroy

    respond_to do |format|
      format.html { redirect_to(case_discussionss_url) }
      format.xml  { head :ok }
    end
  end
end
