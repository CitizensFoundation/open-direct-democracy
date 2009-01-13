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
 
class DocumentStatesController < ApplicationController
  layout "citizen"

  # GET /document_states
  # GET /document_states.xml
  def index
    @document_states = DocumentState.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @document_states }
    end
  end

  # GET /document_states/1
  # GET /document_states/1.xml
  def show
    @document_state = DocumentState.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document_state }
    end
  end

  # GET /document_states/new
  # GET /document_states/new.xml
  def new
    @document_state = DocumentState.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document_state }
    end
  end

  # GET /document_states/1/edit
  def edit
    @document_state = DocumentState.find(params[:id])
  end

  # POST /document_states
  # POST /document_states.xml
  def create
    @document_state = DocumentState.new(params[:document_state])

    respond_to do |format|
      if @document_state.save
        flash[:notice] = 'DocumentState was successfully created.'
        format.html { redirect_to(@document_state) }
        format.xml  { render :xml => @document_state, :status => :created, :location => @document_state }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @document_state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /document_states/1
  # PUT /document_states/1.xml
  def update
    @document_state = DocumentState.find(params[:id])

    respond_to do |format|
      if @document_state.update_attributes(params[:document_state])
        flash[:notice] = 'DocumentState was successfully updated.'
        format.html { redirect_to(@document_state) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document_state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /document_states/1
  # DELETE /document_states/1.xml
  def destroy
    @document_state = DocumentState.find(params[:id])
    @document_state.destroy

    respond_to do |format|
      format.html { redirect_to(document_states_url) }
      format.xml  { head :ok }
    end
  end
end
