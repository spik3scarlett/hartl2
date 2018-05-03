module SessionsHelper
  def log_in(user)
   session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id]) # jezeli da sie przypisac user_id do session[:user_id] (tylko jesli to ostatnie ISTNIEJE!)
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
        if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
    #nie ma else, bo inaczej current_user nie istnieje - nikt nie jest zalogowany
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def log_out
     forget(current_user) #odwoluje sie do metody z session helper (patrz dalej)
     session.delete(:user_id) # likwiduje tymczasowe cookie sessji
     @current_user = nil
   end

   def remember(user) # pierwsza linijka tworzy token i zapisuje jego zahaszowana wersje w bazie,
     # druga i trzecia zapisuja zaszyfrowane cookie ID i TOKENA w przegladarce
     user.remember
     cookies.permanent.signed[:user_id] = user.id
     cookies.permanent[:remember_token] = user.remember_token
   end

   # Returns true if the given user is the current user.
     def current_user?(user)
       user == current_user
     end

   # Forgets a persistent session. Pierwsza linijka likwiduje z modelu zaszyfrowany token (remember_digest)
   def forget(user)
     user.forget
     cookies.delete(:user_id)
     cookies.delete(:remember_token)
   end

     # Redirects to stored location (or to the default).
   def redirect_back_or(default)
     redirect_to(session[:forwarding_url] || default)
     session.delete(:forwarding_url)
   end

   # Stores the URL trying to be accessed.
   def store_location
     session[:forwarding_url] = request.original_url if request.get?
   end

end
