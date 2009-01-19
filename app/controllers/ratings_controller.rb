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
 
class RatingsController < ApplicationController
  before_filter :get_class_by_name
  
  def rate  
    rateable = @rateable_class.find(params[:id])         

    # Delete the old ratings for current user  
    Rating.delete_all(["rateable_type = ? AND rateable_id = ? AND user_id = ?", @rateable_class.base_class.to_s, params[:id], session[:user_id]])  
    rateable.add_rating Rating.new(:rating => params[:rating], :user_id => session[:user_id])  
           
    render :update do |page|  
      if params[:smaller]==nil
        page.replace_html "star-ratings-block-#{rateable.id}_#{rateable.class.name}", :partial => "rate", :locals => { :asset => rateable }        
      else
        page.replace_html "star-ratings-block-#{rateable.id}_#{rateable.class.name}_all", :partial => "rate_smaller", :locals => { :asset => rateable, :postfix=>"all"}
        page.visual_effect :highlight, "star-ratings-block-#{rateable.id}_#{rateable.class.name}_all"
        page << "if ($('star-ratings-block-#{rateable.id}_#{rateable.class.name}_7_days')) {"
        page.replace_html "star-ratings-block-#{rateable.id}_#{rateable.class.name}_7_days", :partial => "rate_smaller", :locals => { :asset => rateable, :postfix=>"7_days"}
        page.visual_effect :highlight, "star-ratings-block-#{rateable.id}_#{rateable.class.name}_7_days"      
        page << "}"         
      end
    end
  end
 
  protected  
     
  # Gets the rateable class based on the params[:rateable_type]  
  def get_class_by_name  
    bad_class = false  
    begin  
      @rateable_class = Module.const_get(params[:rateable_type])  
    rescue NameError  
      # The user is messing with the content_class...  
      bad_class = true  
    end   
      
    # This means the user is doing something funky...naughty naughty...  
    if bad_class  
      redirect_to home_url  
      return false  
    end
    true  
  end   
end