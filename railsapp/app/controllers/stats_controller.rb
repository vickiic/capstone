class StatsController < ApplicationController
  def index
    @patient = params[:id]
    if @patient == nil then
      #if one just goes to the stats page, just show one of the patients. Helps with tests as well.
      @patient = "12345abc"
    end
    _startYear = params[:startYear]
    _startMonth = params[:startMonth]
    _startDay = params[:startDay]
    _endYear = params[:endYear]
    _endMonth = params[:endMonth]
    _endDay = params[:endDay]

    # _api = JSON.parse File.read(Rails.root.join("app/assets/api.json"))
    if (params[:commit] == nil) then
      @heartrates = Heartrate.where("device = ?", @patient)
    else
      #check for nil
      if _startYear == '' || _startYear == nil then
        _startYear = '0'
      end
      if _startMonth == '' || _startMonth == nil then
        _startMonth = '1'
      end
      if _startDay == '' || _startDay == nil then
        _startDay = '1'
      end
      if _endYear == '' || _endYear == nil then
        _endYear = Time.now.strftime("%Y")
      end
      if _endMonth == '' || _endMonth == nil then
        _endMonth = Time.now.strftime("%m")
      end
      if _endDay == '' || _endDay == nil then
        _endDay = Time.now.strftime("%d")
      end

      # puts "Start Year: " + _startYear
      # puts "Start Month: " + _startMonth
      # puts "Start Day: " + _startDay
      # puts "End Year: " + _endYear
      # puts "End Month: " + _endMonth
      # puts "End Day: " + _endDay

      _startDate = Date.new(_startYear.to_i, _startMonth.to_i, _startDay.to_i)
      _endDate = Date.new(_endYear.to_i, _endMonth.to_i, _endDay.to_i)
      puts _startDate
      puts _endDate
      # @heartrates = Heartrate.where("device = ?", @patient)
      @heartrates = Heartrate.where("device = ? AND created_at > ? AND created_at < ?", @patient, _startDate, _endDate)
    end
  end
end
