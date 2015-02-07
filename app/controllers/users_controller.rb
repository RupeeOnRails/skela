class UsersController < ApplicationController

  before_filter :authenticate, except: [:new, :create]
  before_filter :authorize_superuser, only: [:destroy, :admin_create]

  def index
    @users = User.all
  end

  def update
    @user = User.find params[:id]

    unless current_user.is_superuser?
      if @user != current_user
        redirect_to users_path, alert: 'You cannot edit someone else\'s profile.'
        return
      end
    end

    if @user.update(user_params)
      redirect_to users_path, notice: 'User updated successfully!'
    else
      redirect_to welcome_path, alert: 'Something happened'
    end
  end

  def new
    @user = User.new
  end

  def create
    if @user = User.create(user_params)
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Thank you for signing up, welcome to Skela!'
    else
      render 'new'
    end
  end

  def edit
    @user = User.find params[:id]
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @user = User.find params[:id]
    if @user.destroy
      redirect_to users_path, notice: 'User successfully deleted!'
    end
  end

  def admin_new
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

  def admin_create
    if @user = User.create(user_params)
      redirect_to users_path, notice: 'User created successfully!'
    else
      render 'user_path'
    end
  end

  def my_profile
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :privelage_level, :avatar, :favorite_color)
  end

end
