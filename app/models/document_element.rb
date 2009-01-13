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

class DocumentElement < ActiveRecord::Base
  belongs_to :user
  belongs_to :document
  
  acts_as_rateable

  def comments_against
    DocumentComment.find(:all, :conditions => ["document_element_id = ? and bias < 0", self.id])
  end
  
  def comments_not_sure
    DocumentComment.find(:all, :conditions => ["document_element_id = ? and bias = 0", self.id])
  end
  
  def comments_in_support
    DocumentComment.find(:all, :conditions => ["document_element_id = ? and bias > 0", self.id])
  end

end
