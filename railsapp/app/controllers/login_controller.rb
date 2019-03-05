class LoginController < ApplicationController
  def index
    @invalid = !(params[:invalid] == nil)
  end
  def authenticate
    _username = params[:username]
    _password = params[:password]

    if _username == "admin"
      redirect_to welcome_index_path and return
    end
    redirect_to login_index_path(invalid: true)
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
