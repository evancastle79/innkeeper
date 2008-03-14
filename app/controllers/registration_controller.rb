class RegistrationController < ApplicationController
  
  def send_welcome_email
    # triggered via:
    # http://localhost:PORT/registration/send_welcome_email
 
    # note the deliver_ prefix, this is IMPORTANT
    Postoffice.deliver_welcome("John Perkins", "john.d.perkins@gmail.com") #@user.name, @user.email)
 
    # optional
    flash[:notice] = "You've successfuly registered. Please check your email for a confirmation!"
 
    # render the default action
    render :template => 'layouts/application', :layout => false
  end

  def unsubscribe
    
  end
end
