class LoginController < ApplicationController
  def index
    @incorrect = if params[:incorrect] == nil then false else true end
    puts @incorrect
  end
  def authenticate
    _login = params[:q]
    _password = params[:w]

    if _login == "admin"
      redirect_to welcome_index_path(param_1: _login, param_2:_password) and return
    end
    redirect_to login_index_path(incorrect: true)
  end
end
