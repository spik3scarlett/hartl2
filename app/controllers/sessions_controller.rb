class SessionsController < ApplicationController
  def new
  end

  def create
   user = User.find_by(email: params[:session][:email].downcase)
   if user && user.authenticate(params[:session][:password])
     log_in user
     params[:session][:remember_me] == '1' ? remember(user) : forget(user) # jesli checkbox remember zaznaczony
     # nastepuje remember, czyli odwoluje sie do metody remember z sessions helpera - tworzy
     # token i jego zahaszowana wersje zapisuje w bazie oraz od razu zapisuje cookiesy
     # jesli nie jest zaznaczony, nastepuje forget user
     redirect_back_or user # metoda z session helper: jesli wymuszono zalogowanie, bedzie cookie z URLem z ktorego zostal przekierowany i tu zostanie redirect_to
    # jesli nie wymuszano, to przejdzie do user

    
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
