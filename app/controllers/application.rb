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

SSL_PROTOCOL = "https"

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :check_authentication,
                :check_authorization,
                :set_locale,
                :log_user_email,
                :log_referer,
                :check_frames

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '216851400334e64c3cf4dcd55b6527cf'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  private
  
  def log_referer
    logger.info("Referer - #{request.referer}")
  end
  
  def log_user_email
     if session[:user_id]
       user = User.find(session[:user_id])
       if user and user.email
         info("user => #{user.email}")
       elsif user and user.citizen_id
         info("user => #{user.full_name} (eid user)")
       end
     else
       info("user => anonymous")
     end
  end
  
  def set_locale
    unless request.host.downcase=="direct.democracy.is"
      I18n.locale = :is
    else
      I18n.locale = :en
    end
  end
  
  def notify_administrators(subject, body)
    admin_email = AdminMailer.create_critical_error(subject, body)
    admin_email.set_content_type("text/html")
    AdminMailer.deliver(admin_email)
  end
  
  def redirect_to_ssl
    redirect_to url_for(params.merge({:protocol => SSL_PROTOCOL})) unless (request.ssl? or local_request? or SSL_PROTOCOL == "http://")
  end
   
  def check_authentication
    user = User.find_by_id(session[:user_id])
    if user == nil
      if xml_request?
        xml_error("RedirectLogin", "Login Needed")
        debug("check_authentication login redirect")
        return false
      else
        session[:intended_action] = action_name
        session[:intended_controller] = controller_name
        session[:params] = params
        redirect_to(:controller => "users", :action => "login")
        return false
      end
    else
      session[:user_email] = user.email
    end
  end

  def check_authorization
    if session[:user_id]
      user = User.find(session[:user_id])
      unless user.roles.detect{|role|
        role.rights.detect{|right|
          (right.action == action_name || right.action == "*") && right.controller == self.class.controller_path
          }
        }
        if xml_request?
          xml_error("RedirectSignup", "")
        else
          flash[:notice] = "You are not authorized to view the page you requested"
          error("authorization failed for user: #{session[:user_id]}")
          redirect_to(:controller => "users", :action => "login")
        end
        return false
      end
    else
      check_authentication
    end
  end

  def redirect_to_index(msg = nil)
    error("Redirect to index with: #{msg}")
    notify_administrators("Redirect to Index Error", "#{msg} for user: #{session[:user_id]}")
    if xml_request?
      if msg
        xml_error("RedirectRestart", msg)
      else
        warn("Redirecting without error message when in xml mode")
      end
    else
      flash[:notice] = msg if msg
      if @brand.global_brand_access == true
        redirect_to :controller => "catalogue", :action => :brands, :protocol => 'http://'
      else
        redirect_to :controller => "catalogue", :action => :index, :protocol => 'http://'
      end
    end
    return false
  end

  def xml_error(code, message, errors = nil)
    @xml_error_code = code
    @xml_error_message = message
    @xml_error_details = errors
    render :file => 'shared/error.rxml', :layout => false, :use_full_path => true
  end

  def check_frames
    if request.referer=="http://almannathing.is/" or request.referer=="http://www.almannathing.is/"
      info("Removing outer frame so SSL and electronic ids can work")
      redirect_to :controller=>"users", :action=>"get_out_of_frames"
    end
  end
  
  def configure_charsets
    if request.xhr?
      response.headers["Content-Type"] ||= "text/javascript; charset=iso-8859-1"
#    else
#      response.headers["Content-Type"] ||= "text/html; charset=iso-8859-1"
    end
  end
  
  def user_id
    if session[:user_id]
      session[:user_id]
    else
      -1
    end
  end

  def log_time
    t = Time.now
    "%02d/%02d %02d:%02d:%02d.%06d" % [t.day, t.month, t.hour, t.min, t.sec, t.usec]
  end

  def info(text)
    logger.info("cs_info %s %s %s %d %s %s: %s" % [log_time, params[:xml_request] ? "xml" : "web", request.remote_ip, user_id, controller_name, action_name, text])
  end

  def warn(text)
    logger.warn("cs_warn %s %s %s %d %s %s: %s" % [log_time, params[:xml_request] ? "xml" : "web", request.remote_ip, user_id, controller_name, action_name, text])
  end

  def error(text)
    logger.error("cs_error %s %s %s %d %s %s: %s" % [log_time, params[:xml_request] ? "xml" : "web", request.remote_ip, user_id, controller_name, action_name, text])
  end

  def debug(text)
    logger.debug("cs_debug %s %s %s %d %s %s: %s" % [log_time, params[:xml_request] ? "xml" : "web", request.remote_ip, user_id, controller_name, action_name, text])
  end
  
  def paginate_collection(collection, options = {})
    default_options = {:per_page => 10, :page => 1}
    options = default_options.merge options

    debug("Set page to #{options[:page]}")

    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end
  
  def xml_request?
    debug("Content Type: #{request.content_type}")
    debug("Accepts: #{request.accepts}")
    params[:xml_request] || request.content_type == "application/xml" || request.content_type == "text/xml" || request.accepts.to_s == "application/xml"
  end
end