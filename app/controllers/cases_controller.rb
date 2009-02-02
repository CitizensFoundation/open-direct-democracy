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

class CasesController < ApplicationController
  layout "citizen"
  
  skip_before_filter :check_authentication, :only =>  [ :index, :show ]
  skip_before_filter :check_authorization, :only =>  [ :index, :show ]  

  # GET /cases
  # GET /cases.xml
  def index
    @cases = Case.find(:all, :order=>"external_id DESC")
    @most_important_cases = @cases.sort_by { |x| [-x.rating, -x.ratings.size] }
    @last_comments = []
    DocumentComment.find(:all, :limit=>5, :select => 'DISTINCT(user_id)',:order=>"document_comments.created_at DESC").each do |comment_include|
      @last_comments << User.find(comment_include.user).document_comments.find(:last)
    end
    
    @latest_votes = Vote.find(:all, :limit=>7, :order=>"votes.created_at DESC", :select => 'DISTINCT(document_id)', :include=>"document" )
    @latest_speech_discussions = []
    CaseSpeechVideo.find(:all, :conditions=>"published = 1", :limit=>15, :select => 'DISTINCT(case_discussion_id)', 
                         :include=>"case_discussion", :order=>"updated_at DESC").each do |case_discussion_include|
      case_discussion = case_discussion_include.case_discussion
      @latest_speech_discussions << case_discussion if case_discussion.case_speech_videos.all_done?
    end

    last_weeks_discussion = CaseDiscussion.find(:all, :conditions=>["created_at >= ?",Time.now-1.weeks])
    last_weeks_documents = CaseDocument.find(:all, :conditions=>["created_at >= ?",Time.now-1.weeks])

    if not last_weeks_discussion.empty? or not last_weeks_documents.empty?
      @cases_changed_past_7_days = []
      last_weeks_discussion.each do |d|
        @cases_changed_past_7_days << d.case
      end
      last_weeks_documents.each do |d|
        @cases_changed_past_7_days << d.case
      end
      @cases_changed_past_7_days = @cases_changed_past_7_days.uniq.sort_by { |x| [-x.rating, -x.ratings.size] }
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cases }
    end
  end

  # GET /cases/1
  # GET /cases/1.xml
  def show
    @my_case = @case = Case.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @case }
    end
  end

  # GET /cases/new
  # GET /cases/new.xml
  def new
    @case = Case.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @case }
    end
  end

  # GET /cases/1/edit
  def edit
    @case = Case.find(params[:id])
  end

  # POST /cases
  # POST /cases.xml
  def create
    @case = Case.new(params[:case])

    respond_to do |format|
      if @case.save
        flash[:notice] = 'Case was successfully created.'
        format.html { redirect_to(@case) }
        format.xml  { render :xml => @case, :status => :created, :location => @case }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @case.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cases/1
  # PUT /cases/1.xml
  def update
    @case = Case.find(params[:id])

    respond_to do |format|
      if @case.update_attributes(params[:case])
        flash[:notice] = 'Case was successfully updated.'
        format.html { redirect_to(@case) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @case.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cases/1
  # DELETE /cases/1.xml
  def destroy
    @case = Case.find(params[:id])
    @case.destroy

    respond_to do |format|
      format.html { redirect_to(cases_url) }
      format.xml  { head :ok }
    end
  end
end
