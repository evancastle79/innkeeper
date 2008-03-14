class UsersController < ApplicationController

  before_filter :login_required, :except => [ :create ]
  
  def index
    @users = User.find(:all)
  end
  
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token

    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      flash.now[:error] = "We're sorry, there was an error creating your account. Please try again."
      render :action => 'new'
    end
  end

  # Remove a user only if the removing party has the correct role...
  def destroy
    if self.current_user.has_role?("innkeeper")
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "Destroyed user #{@user.login}."
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      end
    else 
      flash[:error] = "You must be the Innkeeper to delete a user."
      redirect_back_or_default('/')
    end   
  end
  
end
