class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
     flash.now[:danger] = 'Zły login lub hasło'
     render 'new'
    end
  end

  def destroy
    log_out if logged_in? # powoduje wylogowanie tylko jesli user jest zalogowany.
    # jesli wiec ktos sie wyloguje w jednym oknie to klikniecie wyloguj w innym oknie nie zwroci bledu
    # tylko spowoduje przejscie do kolejnej linijki kodu
    redirect_to root_url
  end
end
