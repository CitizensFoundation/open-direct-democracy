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
 
class DocumentCommentsController < ApplicationController
  layout "citizen"

  # GET /document_comments
  # GET /document_comments.xml
  def index
    @document_comments = DocumentComment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @document_comments }
    end
  end

  # GET /document_comments/1
  # GET /document_comments/1.xml
  def show
    @document_comment = DocumentComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document_comment }
    end
  end

  # GET /document_comments/new
  # GET /document_comments/new.xml
  def new
    @document_comment = DocumentComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document_comment }
    end
  end

  # GET /document_comments/1/edit
  def edit
    @document_comment = DocumentComment.find(params[:id])
  end

  # POST /document_comments
  # POST /document_comments.xml
  def create
    params[:document_comment][:user_id]=session[:user_id]
    params[:document_comment][:bias]=0.0 unless params[:document_comment][:bias]
    @document_comment = DocumentComment.new(params[:document_comment])
    if request.xhr?
      if @document_comment.save
        @document = Document.find(@document_comment.document_id)
        if @document_comment.document_element_id
          replace_div = "comment_panel_master_for_DocumentElement_#{@document_comment.document_element_id}"
          comment_target = DocumentElement.find(@document_comment.document_element_id)
        else
          replace_div = "comment_panel_master_for_Document_#{@document.id}"        
          comment_target = @document
        end
        render :update do |page|  
          page.replace_html replace_div, :partial => "comment_on", :locals => { :document=> @document, :comment_target => comment_target, :open_panel => true }  
          page.visual_effect :highlight, replace_div  
        end
      else
        error("Could not save comment")
      end
    else   
      respond_to do |format|
        if @document_comment.save
          flash[:notice] = 'DocumentComment was successfully created.'        
          format.html { redirect_to(:controller => "documents", :action=>"show", :id => @document_comment.document_id) }
          format.xml  { render :xml => @document_comment, :status => :created, :location => @document_comment }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @document_comment.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /document_comments/1
  # PUT /document_comments/1.xml
  def update
    @document_comment = DocumentComment.find(params[:id])

    respond_to do |format|
      if @document_comment.update_attributes(params[:document_comment])
        flash[:notice] = 'DocumentComment was successfully updated.'
        format.html { redirect_to(@document_comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /document_comments/1
  # DELETE /document_comments/1.xml
  def destroy
    @document_comment = DocumentComment.find(params[:id])
    @document_comment.destroy

    respond_to do |format|
      format.html { redirect_to(document_comments_url) }
      format.xml  { head :ok }
    end
  end
end
