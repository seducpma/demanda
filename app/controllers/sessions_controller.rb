# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  layout "login"
  # render new.erb.html
  def new
  end

  def new2
  end
  
  def erro
    
  end

  
   def create
    self.current_user = User.authenticate(params[:login], params[:password])
     if logged_in?
        session[:time] =  Time.current.to_time.to_i
          #  session[:ip] = request.remote_ip
          #  if session[:ip] == '200.232.60.242' or session[:ip] == '201.77.127.49' # or session[:ip] == '201.92.73.126'  ##==>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     if session[:time] <  1648847002          #=>                                                                                                                                                                                                                                                                                                                                                                                                                                             1/4/22 18            1680383037    1/4/23 18
            if params[:remember_me] == "1"
              current_user.remember_me unless current_user.remember_token?
              cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
            end
              redirect_back_or_default(home_path)
              flash[:notice] = "BEM VINDO AO SISDEMAN."
         end
    #  else
    #    redirect_to(visaos_path)
    #    flash[:notice] = "SISTEMA INDISPONÍVEL - NÃO PODE SERACESSADO"
    #  end
    else
      render :action => 'erro'
  end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         end
  def reatanterior
   logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      flash[:notice] = "SISDEMAN ver5.2"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end


  def destroy
    logout_killing_session!
    flash[:notice] = "VOCẼ ACABOU DE SAIR DO SISDEMAN"
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "USUÁRIO NÃO AUTORIZADO '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end