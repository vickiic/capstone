class StatsController < ApplicationController
  def index
    api = JSON.parse File.read(Rails.root.join("app/assets/api.json"))
    _response = HTTParty.get(
        'https://devices.intouchhealth.com/api/v1/static_field_values/heartRate?device_uid=ccb53ec5-cb64-4de4-bdd0-9bdc6e331683',
        headers: { 'ITH-API-Key': api["key"],
                   'ITH-Username': api["username"],
                   'Content-Type': 'application/json' }
    )
    _body = JSON.parse(_response.body)
    @body = _body
  end
end
