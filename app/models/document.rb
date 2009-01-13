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
 
class Document < ActiveRecord::Base
  belongs_to :user
  has_many :document_elements
  belongs_to :case_document

  def vote_by_user(user_id)
    vote = Vote.find_by_document_id(self.id, :conditions=>["user_id = ?", user_id])
    if vote
      if vote.agreed == true
        return ["in_support",""]
      else
        return ["against",""]
      end
    else
      vote_proxy = VoteProxy.find(:first, :conditions=> ["category_id = ? and from_user_id = ?", self.category_id, user_id])
      if vote_proxy
        proxy_vote = Vote.find_by_document_id(self.id, :conditions=>["user_id = ?", vote_proxy.to_user_id])
        if proxy_vote
          if proxy_vote.agreed == true
            return ["in_support_proxy",vote_proxy.name_with_initial_and_citizen_id]
          else
            return ["against_proxy",vote_proxy.name_with_initial_and_citizen_id]
          end
        else
          return nil
        end
      else
        return nil
      end
    end
  end

  def vote_id_by_user(user_id)
    vote = Vote.find_by_document_id(self.id, :conditions=>["user_id = ?", user_id])
    if vote
      return vote.id
    else
      return nil
    end
  end

  def comments_against
    DocumentComment.find(:all, :conditions => ["document_id = ? and bias < 0 and document_element_id is null", self.id])
  end
  
  def comments_not_sure
    DocumentComment.find(:all, :conditions => ["document_id = ? and bias = 0 and document_element_id is null", self.id])
  end
  
  def comments_in_support
    DocumentComment.find(:all, :conditions => ["document_id = ? and bias > 0 and document_element_id is null", self.id])
  end
  
  def get_all_change_proposals_for_sequence_number(sequence_number)
    proposals = []
    # First get the original
    proposals << DocumentElement.find(:first, :conditions => ["document_id = ? AND sequence_number = ? AND original_version = 1",self.id,sequence_number])
    change_proposals = DocumentElement.find(:all, :conditions => ["document_id = ? AND sequence_number = ? AND original_version = 0",self.id,sequence_number])
    for change_proposal in change_proposals
      proposals << change_proposal
    end
    proposals
  end
end
