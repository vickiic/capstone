class WelcomeController < ApplicationController
  def index
    @search = params[:searchInput]
    if @search == nil
      @search = ""
    end
    api = JSON.parse File.read(Rails.root.join("app/assets/api.json"))
    _response = HTTParty.get(
        'https://devices.intouchhealth.com/api/v1/devices',
        headers: { 'ITH-API-Key': api["key"],
                   'ITH-Username': api["username"],
                   'Content-Type': 'application/json',
                   'ITH-Device-Type': 'testing'
        }
    )
    @body = JSON.parse(_response.body)
  end
end
