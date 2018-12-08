class StatsController < ApplicationController
  def index
    @patient = params[:id]
    api = JSON.parse File.read(Rails.root.join("app/assets/api.json"))
    _response = HTTParty.get(
        'https://devices.intouchhealth.com/api/v1/static_field_values/heartRate?device_uid=' + params[:id],
        headers: { 'ITH-API-Key': api["key"],
                   'ITH-Username': api["username"],
                   'Content-Type': 'application/json' }
    )
    _body = JSON.parse(_response.body)
    @body = _body
  end
end
