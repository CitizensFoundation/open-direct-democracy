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
 
class DocumentElementsController < ApplicationController
  # GET /document_elements
  # GET /document_elements.xml
  def index
    @document_elements = DocumentElement.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @document_elements }
    end
  end

  # GET /document_elements/1
  # GET /document_elements/1.xml
  def show
    @document_element = DocumentElement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document_element }
    end
  end

  # GET /document_elements/new
  # GET /document_elements/new.xml
  def new
    @document_element = DocumentElement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document_element }
    end
  end

  # GET /document_elements/1/edit
  def edit
    @document_element = DocumentElement.find(params[:id])
  end

  # POST /document_elements
  # POST /document_elements.xml
  def create
    @document_element = DocumentElement.new(params[:document_element])

    respond_to do |format|
      if @document_element.save
        flash[:notice] = 'DocumentElement was successfully created.'
        format.html { redirect_to(@document_element) }
        format.xml  { render :xml => @document_element, :status => :created, :location => @document_element }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @document_element.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /document_elements/1
  # PUT /document_elements/1.xml
  def update
    @document_element = DocumentElement.find(params[:id])

    respond_to do |format|
      if @document_element.update_attributes(params[:document_element])
        flash[:notice] = 'DocumentElement was successfully updated.'
        format.html { redirect_to(@document_element) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document_element.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /document_elements/1
  # DELETE /document_elements/1.xml
  def destroy
    @document_element = DocumentElement.find(params[:id])
    @document_element.destroy

    respond_to do |format|
      format.html { redirect_to(document_elements_url) }
      format.xml  { head :ok }
    end
  end
  
  def new_change_proposal
    @source_element = DocumentElement.find(params[:source_id])
    replace_div = "document_element_number_#{@source_element.sequence_number}"
    render :update do |page|
      page.replace_html replace_div, :partial => "document_elements/new_change_proposal", :locals => {:document=> @source_element.document, :element => @source_element, :open_panel => true }
#      page.visual_effect :highlight, replace_div  
    end
  end

  def create_change_proposal
    source_element = DocumentElement.find(params[:source_id])
    change_proposal = source_element.clone
    change_proposal.user_id = session[:user_id]
    change_proposal.content = params[:source_element][:content]
    change_proposal.content_text_only = ""
    change_proposal.original_version=false
    change_proposal.save
    replace_div = "document_element_number_#{change_proposal.sequence_number}"
    render :update do |page|  
      page.replace_html replace_div, :partial => "document_elements/element", :locals => {:document=> change_proposal.document, :element => change_proposal, :open_panel => true }
      page.visual_effect :highlight, replace_div
    end
  end

  def cancel_new_change_proposal
    source_element = DocumentElement.find(params[:source_id])
    replace_div = "document_element_number_#{source_element.sequence_number}"
    render :update do |page|  
      page.replace_html replace_div, :partial => "document_elements/element", :locals => {:document=> source_element.document, :element => source_element, :open_panel => true }
      page.visual_effect :highlight, replace_div  
    end
  end

  def view_element
    source_element = DocumentElement.find(params[:source_id])
    replace_div = "document_element_number_#{source_element.sequence_number}"
    render :update do |page|  
      page.replace_html replace_div, :partial => "document_elements/element", :locals => {:document=> source_element.document, :element => source_element, :open_panel => true }
      page.visual_effect :highlight, replace_div  
    end
  end
end
