class LoginController < ApplicationController
  def index
    @incorrect = if params[:incorrect] == nil then false else true end
  end
  def authenticate
    _login = params[:q]
    _password = params[:w]

    if _login == "admin"
      redirect_to welcome_index_path(param_1: _login, param_2:_password) and return
    end
    redirect_to login_index_path(incorrect: true)
  end

  def gen
    _api = JSON.parse File.read(Rails.root.join("app/assets/api.json"))
    _response = HTTParty.post(
        'https://devices.intouchhealth.com/api/v1/metric_field_values',
        body: { "device_uid": "12345abc",
                "metric_field_values": {
                    "heartRate":
                        {
                            "value": rand(30) + 40,
                            "timestamp": Time.now.strftime("%Y-%m-%dT%H:%M:%S.000Z")
                        }
                }
        }.to_json,
        headers: { 'ITH-API-Key': _api["key"],
                   'ITH-Username': _api["username"],
                   'Content-Type': 'application/json' }
    )
    redirect_to login_index_path
  end
end
