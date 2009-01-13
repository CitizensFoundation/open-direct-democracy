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
 
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def get_short_star_rating(asset,br=false)
   "#{sprintf("%.1f",asset.rating)}/5.0 #{br ? "<br>" : ""} <small>(#{asset.ratings.size} #{t(:votes)})</small>"
 end
end
