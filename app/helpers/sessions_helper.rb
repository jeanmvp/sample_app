module SessionsHelper
	def log_in(user)
		session[:user_id] = user.id
	end

	# Recordar al usuario en una sesión.
    def remember(user)
    	user.remember
    	cookies.permanent.signed[:user_id] = user.id
    	cookies.permanent[:remember_token] = user.remember_token
    end

     # Devuelve verdadero si es el usuario logeado.
    def current_user?(user)
    	user == current_user
    end

	# Devuelve el recordatorio al usuario segun cookie el token
	def current_user
		if (user_id = session[:user_id])
	      @current_user ||= User.find_by(id: user_id)
	    elsif (user_id = cookies.signed[:user_id])
	      user = User.find_by(id: user_id)
	      if user && user.authenticated?(:remember, cookies[:remember_token])
	        log_in user
	        @current_user = user
	      end
	    end
	end

	# Comprueba si ya esta activa la sesión
	def logged_in?
		!current_user.nil?
	end

	# Recuerda la sesión.
    def forget(user)
    	user.forget
    	cookies.delete(:user_id)
    	cookies.delete(:remember_token)
    end

	# Cerrar sesión actual
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	# Redirects to stored location (or to the default).
    def redirect_back_or(default)
	    redirect_to(session[:forwarding_url] || default)
	    session.delete(:forwarding_url)
    end

    # Stores the URL trying to be accessed.
    def store_location
    	session[:forwarding_url] = request.url if request.get?
    end
end
