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

class CaseDiscussion < ActiveRecord::Base
  belongs_to :case
  has_many :case_speech_videos, :order => "case_speech_videos.sequence_number" do
    def has_any?
      find :first, :conditions => "case_speech_videos.published = 1 AND case_speech_videos.in_processing = 0"
    end

    def get_all_published
      find :all, :conditions => "case_speech_videos.published = 1 AND case_speech_videos.in_processing = 0"
    end
    
    def get_all_for_modified_duration
      find(:all, :conditions=>"case_speech_videos.published = 0 AND case_speech_videos.has_checked_duration = 0", :order=>"case_speech_videos.start_offset", :lock=>true)
    end

    def all_done?
      a = count :all
      b = count :all, :conditions => "case_speech_videos.published = 1"
      a == b and b!=0
    end

    def get_random_published
      find :first, :conditions => "case_speech_videos.published = 1 AND case_speech_videos.in_processing = 0", :order=>"rand()"
    end
    
    def get_first_published
      find :first, :conditions => "case_speech_videos.published = 1 AND case_speech_videos.in_processing = 0", :order=>"case_speech_videos.start_offset"
    end    
  end
end
