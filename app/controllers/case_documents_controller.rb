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

class CaseDocumentsController < ApplicationController
  # GET /case_documents
  # GET /case_documents.xml
  def index
    @case_documents = CaseDocuments.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @case_documents }
    end
  end

  # GET /case_documents/1
  # GET /case_documents/1.xml
  def show
    @case_document_element = CaseDocuments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @case_document_element }
    end
  end

  # GET /case_documents/new
  # GET /case_documents/new.xml
  def new
    @case_document_element = CaseDocuments.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @case_document_element }
    end
  end

  # GET /case_documents/1/edit
  def edit
    @case_document_element = CaseDocuments.find(params[:id])
  end

  # POST /case_documents
  # POST /case_documents.xml
  def create
    @case_document_element = CaseDocuments.new(params[:case_document_element])

    respond_to do |format|
      if @case_document_element.save
        flash[:notice] = 'CaseDocuments was successfully created.'
        format.html { redirect_to(@case_document_element) }
        format.xml  { render :xml => @case_document_element, :status => :created, :location => @case_document_element }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @case_document_element.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /case_documents/1
  # PUT /case_documents/1.xml
  def update
    @case_document_element = CaseDocuments.find(params[:id])

    respond_to do |format|
      if @case_document_element.update_attributes(params[:case_document_element])
        flash[:notice] = 'CaseDocuments was successfully updated.'
        format.html { redirect_to(@case_document_element) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @case_document_element.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /case_documents/1
  # DELETE /case_documents/1.xml
  def destroy
    @case_document_element = CaseDocuments.find(params[:id])
    @case_document_element.destroy

    respond_to do |format|
      format.html { redirect_to(case_documents_url) }
      format.xml  { head :ok }
    end
  end
end
