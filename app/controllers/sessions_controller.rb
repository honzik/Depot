class SessionsController < ApplicationController
  skip_before_filter :authorize
  
  def new
  end

  def create    
        
    # create user if params given and no user in database yet    
    if User.count == 0
      user_created = User.create(:name => params[:name], :password => params[:password])
      if user_created.id.nil?
        respond_to do |format|
          flash[:alert] = "Cannot create first admin user from incomplete credentials"
          format.html {render :action => "new"}
        end        
        return  
      else
        alert = "User of name #{user_created.name} created as first user using given credentials"
      end      
    end  
    
    # authenticate user    
    if user = User.authenticate(params[:name], params[:password])
      session[:user_id] = user.id            
      redirect_to admin_url
    else
      redirect_to login_url, :alert => "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_url, :notice => "Logged out"
  end

end
