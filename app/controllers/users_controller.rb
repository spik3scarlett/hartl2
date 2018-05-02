class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] #tylko przy tych akcjachw tym kontrolerze  konieczne jest logowanie
  # , inaczej byloby wymagane wszedzie
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def index
      @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
   @user = User.find(params[:id])

  end

 def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Rejestracja zakończona sukcesem!"
      redirect_to @user # to jest to samo co > redirect_to user_url(@user) < This is because Rails automatically infers from redirect_to @user that we want to redirect to user_url(@user).
    else
      render 'new'
    end
  end

  def edit
     @user = User.find(params[:id])
  end

  def update
   @user = User.find(params[:id])
    if @user.update_attributes(user_params) #
      flash[:success] = "Profile updated"
      redirect_to @user
    else
        render 'edit'
    end
  end


    private

        def user_params # to jest po to, żeby hijacker nie zapisał w bazie że jest adminem
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end

        # Confirms a logged-in user.
        def logged_in_user
          unless logged_in?
            store_location
            flash[:danger] = "Please log in."
            redirect_to login_url
          end
        end

        def correct_user
           @user = User.find(params[:id])
           redirect_to(root_url) unless current_user?(@user)
        end

            # Confirms an admin user.
        def admin_user
          redirect_to(root_url) unless current_user.admin?
        end
end
