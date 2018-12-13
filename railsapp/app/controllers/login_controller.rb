class LoginController < ApplicationController
  def index
  end
  def authenticate
    _login = params[:q]
    _password = params[:w]

    if _login == "admin"
      redirect_to :controller => 'welcome', action: 'index' and return
    end
    redirect_to :controller => 'login', :action => 'index'
  end
end
