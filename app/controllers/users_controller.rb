class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
   
  end
  
  def create
    @user = User.create( params[:user] )
  end
  
  def edit
    @user = current_user
  end
  
end
