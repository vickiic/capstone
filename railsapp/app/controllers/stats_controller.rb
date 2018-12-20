class StatsController < ApplicationController
  def index
    @patient = params[:format]
    _api = JSON.parse File.read(Rails.root.join("app/assets/api.json"))
    _response = HTTParty.get(
        'https://devices.intouchhealth.com/api/v1/static_field_values/heartRate?device_uid=' + @patient,
        headers: { 'ITH-API-Key': _api["key"],
                   'ITH-Username': _api["username"],
                   'Content-Type': 'application/json' }
    )
    @body = JSON.parse(_response.body)
  end
end
