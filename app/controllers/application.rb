
  # Filters added to this controller apply to all controllers in the application.
  # Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  # You can move this into a different controller, if you wish.  
  # This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  filter_parameter_logging "email", "password", "salt", "city", "state", "zip"
  
  helper :all # include all helpers, all the time
  
  # Require login for everything except the "login" action
  # before_filter :login_required, :except => [:login]
  
  # To require login only for some actions, use:
  # before_filter :login_required, :only => [ :edit, :update ]
  # To skip this in a subclassed controller:
  # skip_before_filter :login_required
  
  def welcome
  end
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '6de4d89288a8166ff46e8b799bedc45b'

end