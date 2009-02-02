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

module CasesHelper
  
  def get_comment_document_case_link(comment)
    if comment.document
      link_to comment.document.case_document.case.external_name.capitalize, :controller=>"documents", :action=>"show", :id=>comment.document.id
    elsif comment.case_speech_video
      link_to comment.case_speech_video.case_discussion.case.external_name.capitalize, :controller=>"case_speech_videos", :action=>"show", :id=>comment.case_speech_video.id
    end
  end

  def get_vote_document_case_link(vote)
    link_to vote.document.case_document.case.external_name.capitalize, :controller=>"documents", :action=>"show", :id=>vote.document.id    
  end  
  
  def get_vote_status_for_document(case_document)
    if case_document.documents!=[]
      out = ""
      case_document.documents.each do |document|
        #TODO: Don't duplicate this code, needs to be in only one place
        #TODO: Implement the recursive vote count
        @votes_in_support = Vote.find(:all, :conditions=>["document_id = ? and agreed = 1", document.id])
        @votes_against = Vote.find(:all, :conditions=>["document_id = ? and agreed = 0", document.id])
    
        @votes_in_support_total = 0
        for vote in @votes_in_support
          # Find all vote proxies for the voter of this vote
          vote_proxy_votes = VoteProxy.find(:all, :conditions=> ["category_id = ? and to_user_id = ?", document.category_id, vote.user.id])
          for proxy_vote in vote_proxy_votes
            # Check to see if the voter has voted on the law already
            unless document.vote_id_by_user(proxy_vote.from_user_id)
              @votes_in_support_total+=1
            end
          end
          @votes_in_support_total+=1
        end
    
        @votes_against_total = 0
        for vote in @votes_against
          vote_proxy_votes = VoteProxy.find(:all, :conditions=> ["category_id = ? and to_user_id = ?", document.category_id, vote.user.id])
          # Find all vote proxies for the voter of this vote
          for proxy_vote in vote_proxy_votes
            # Check to see if the voter has voted on the law already
            unless document.vote_id_by_user(proxy_vote.from_user_id)
              @votes_against_total+=1
            end
          end
          @votes_against_total+=1
        end
        
        if @votes_in_support_total==0 and @votes_against_total==0 and false
          t(:no_votes_have_been_cast_for_this_law)
        else
          out+="<b>#{t(:vote_count_in_support)}: #{@votes_in_support_total}<br>#{t(:vote_count_against)}: #{@votes_against_total}</b>"
        end
      end
      out
    else
      ""
    end
  end
    
  def get_internal_documents_links(case_document)
    if case_document.documents!=[]
      out = ""
      case_document.documents.each do |document|
        if document.original_version
          author = "<b>#{t(:see_and_vote_for_this_document_here)}</b>" #TODO: Remove hack
#          author = t(:original_version)
        elsif document.user
          author = "#{t(:author)}: #{document.user.full_name}"
        else
          author = "#{t(:author)}: unknown"
        end
        out+="#{link_to author, {:controller=>"documents", :action=>"show", :id=>document.id}, {:class=>"participateLinkLarger"}} <br>"
      end
      out
    else
      ""
    end
  end
  
  def latest_video_speech_title(video)
    "#{t(:case)}: #{video.case_discussion.case.info_1} / #{video.case_discussion.stage_sequence_number}. #{t(:stage_sequence_discussion)}"
  end

  def latest_video_speech_description(video)
    "#{t(:case)}: #{video.case_discussion.case.info_1} (#{video.case_discussion.case.info_2}) / #{video.case_discussion.case.info_3} - #{video.case_discussion.stage_sequence_number}. #{t(:stage_sequence_discussion)}"
  end
end
