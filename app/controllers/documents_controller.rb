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
 
class DocumentsController < ApplicationController
  layout "citizen"

  # GET /documents
  # GET /documents.xml
  def index
    @documents = Document.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
    @document = Document.find(params[:id])
    
    @votes_against = Vote.find(:all, :conditions=>["document_id = ? and agreed = 0", @document.id])
    @votes_in_support = Vote.find(:all, :conditions=>["document_id = ? and agreed = 1",@document.id])

    @document_elements = DocumentElement.find(:all, :conditions => ["document_id = ? AND original_version = 1",@document.id], :order=>"sequence_number")
 
    @votes_against_total = 0
    for vote in @votes_against
      vote_proxy_votes = VoteProxy.find(:all, :conditions=> ["category_id = ? and to_user_id = ?", @document.category_id, vote.user.id])
      # Find all vote proxies for the voter of this vote
      for proxy_vote in vote_proxy_votes
        # Check to see if the voter has voted on the law already
        unless @document.vote_id_by_user(proxy_vote.from_user_id)
          @votes_against_total+=1
        end
      end
      @votes_against_total+=1
    end

    @votes_in_support_total = 0
    for vote in @votes_in_support
      # Find all vote proxies for the voter of this vote
      vote_proxy_votes = VoteProxy.find(:all, :conditions=> ["category_id = ? and to_user_id = ?", @document.category_id, vote.user.id])
      for proxy_vote in vote_proxy_votes
        # Check to see if the voter has voted on the law already
        unless @document.vote_id_by_user(proxy_vote.from_user_id)
          @votes_in_support_total+=1
        end
      end
      @votes_in_support_total+=1
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.xml
  def new
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
  end

  # POST /documents
  # POST /documents.xml
  def create
    @document = Document.new(params[:document])

    respond_to do |format|
      if @document.save
        flash[:notice] = 'Document was successfully created.'
        format.html { redirect_to(@document) }
        format.xml  { render :xml => @document, :status => :created, :location => @document }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.xml
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        flash[:notice] = 'Document was successfully updated.'
        format.html { redirect_to(@document) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to(documents_url) }
      format.xml  { head :ok }
    end
  end
end
