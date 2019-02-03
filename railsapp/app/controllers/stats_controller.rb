class StatsController < ApplicationController
  def index
    @patient = params[:id]
    if @patient == nil then
      #if one just goes to the stats page, just show one of the patients. Helps with tests as well.
      @patient = "12345abc"
    end
    @startYear = params[:startYear]
    @startMonth = params[:startMonth]
    @startDay = params[:startDay]
    @endYear = params[:endYear]
    @endMonth = params[:endMonth]
    @endDay = params[:endDay]

    # _api = JSON.parse File.read(Rails.root.join("app/assets/api.json"))
    if (params[:commit] == nil) then
    #   _response = HTTParty.get(
    #       'https://devices.intouchhealth.com/api/v1/static_field_values/heartRate?device_uid=' + @patient + '&limit=1000',
    #       headers: { 'ITH-API-Key': _api["key"],
    #                  'ITH-Username': _api["username"],
    #                  'Content-Type': 'application/json' }
    #   )
    else
      #check for nil
      if @startYear == '' then
        @startYear = '0000'
      end
      if @startMonth == '' then
        @startMonth = '01'
      end
      if @startDay == '' then
        @startDay = '01'
      end
      if @endYear == '' || @endYear == nil then
        @endYear = Time.now.strftime("%Y")
      end
      if @endMonth == '' || @endMonth == nil then
        @endMonth = Time.now.strftime("%m")
      end
      if @endDay == '' || @endDay == nil then
        @endDay = Time.now.strftime("%d")
      end

      # puts "Start Year: " + @startYear
      # puts "Start Month: " + @startMonth
      # puts "Start Day: " + @startDay
      # puts "End Year: " + @endYear
      # puts "End Month: " + @endMonth
      # puts "End Day: " + @endDay


      #add preceding '0' to day fields if single digits
      if @startDay.length == 1 then
        @startDay = '0' + @startDay
      end
      if @endDay.length == 1 then
        @endDay = '0' + @endDay
      end
      if @startMonth.length == 1 then
        @startMonth = '0' + @startMonth
      end
      if @endMonth.length == 1 then
        @endMonth = '0' + @endMonth
      end

      # _response = HTTParty.get(
      #     'https://devices.intouchhealth.com/api/v1/static_field_values/heartRate?device_uid=' + @patient + '&datetime_begin=' + @startYear + '-' + @startMonth + '-' + @startDay + 'T00:00:00-07:00&datetime_end=' + @endYear + '-' + @endMonth + '-' + @endDay + 'T23:41:37-07:00&limit=1000',
      #     headers: { 'ITH-API-Key': _api["key"],
      #                'ITH-Username': _api["username"],
      #                'Content-Type': 'application/json' }
      # )
    end
    # @body = JSON.parse(_response.body)
    @heartrates = Heartrate.where("device = ?", @patient)
    # @heartrates = Heartrate.all.where(:device, @patient)
  end
end
