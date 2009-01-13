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
 
class VoteProxy < ActiveRecord::Base

  def name_with_initial_and_citizen_id
    user = User.find(to_user_id)
    "#{user.first_name} #{user.last_name} : #{user.citizen_id}"
  end
  
  def full_name_of_from_user
    user = User.find(from_user_id)
    "#{user.first_name} #{user.last_name}"
  end
end
