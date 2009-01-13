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

class CaseTypesController < ApplicationController
  # GET /case_types
  # GET /case_types.xml
  def index
    @case_types = CaseType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @case_types }
    end
  end

  # GET /case_types/1
  # GET /case_types/1.xml
  def show
    @case_type = CaseType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @case_type }
    end
  end

  # GET /case_types/new
  # GET /case_types/new.xml
  def new
    @case_type = CaseType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @case_type }
    end
  end

  # GET /case_types/1/edit
  def edit
    @case_type = CaseType.find(params[:id])
  end

  # POST /case_types
  # POST /case_types.xml
  def create
    @case_type = CaseType.new(params[:case_type])

    respond_to do |format|
      if @case_type.save
        flash[:notice] = 'CaseType was successfully created.'
        format.html { redirect_to(@case_type) }
        format.xml  { render :xml => @case_type, :status => :created, :location => @case_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @case_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /case_types/1
  # PUT /case_types/1.xml
  def update
    @case_type = CaseType.find(params[:id])

    respond_to do |format|
      if @case_type.update_attributes(params[:case_type])
        flash[:notice] = 'CaseType was successfully updated.'
        format.html { redirect_to(@case_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @case_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /case_types/1
  # DELETE /case_types/1.xml
  def destroy
    @case_type = CaseType.find(params[:id])
    @case_type.destroy

    respond_to do |format|
      format.html { redirect_to(case_types_url) }
      format.xml  { head :ok }
    end
  end
end
