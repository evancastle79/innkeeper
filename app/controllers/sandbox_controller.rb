class SandboxController < ApplicationController
  def prep
    session[:apple] = "an apple"
    redirect_to :action => 'show'
  end
  
  def show
    @apple = session[:apple]
  end
end