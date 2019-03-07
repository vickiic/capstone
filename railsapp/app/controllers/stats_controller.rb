class StatsController < ApplicationController
  def index
    @patient = params[:id]
    if @patient == nil then
      #if one just goes to the stats page, just show one of the patients. Helps with tests as well.
      @patient = "12345abc"
    end
    @picture = Patient.where(device: @patient).take
    _startYear = params[:startYear]
    _startMonth = params[:startMonth]
    _startDay = params[:startDay]
    _endYear = params[:endYear]
    _endMonth = params[:endMonth]
    _endDay = params[:endDay]

    if (params[:commit] == nil) then
      @heartrates = Heartrate.where("device = ?", @patient).order(:Time)

      hourlyAverageToday = Array.new(24)
      hourlyTimeToday = Array.new(24)
      (0..23).each do |i|
        (0..6).each do |j|
          current = Heartrate.where("device = ? AND time >= ? AND time <= ?",
            @patient,
            (DateTime.now - (0.04166*(i+1)) - 0.33333).at_beginning_of_hour,
            (DateTime.now - (0.04166*i) - 0.33333).at_beginning_of_hour
            )
            avg = current.average(:value)
          if(avg)
            hourlyAverageToday[avg] = hourlyAverageToday[avg] + avg
          else 
            hourlyAverageToday.push("NaN")
          end
        hourlyTimeToday.push((DateTime.now - (0.0416*i)).at_beginning_of_hour)
      end

      @hourlyAverageToday = hourlyAverageToday
      @hourlyTimeToday = hourlyTimeToday

      hourlyAverageYesterday = Array.new
      (0..24).each do |i|
        current = Heartrate.where("device = ? AND time >= ? AND time <= ?",
          @patient,
          (DateTime.now - (0.04166*(i+1)) - 0.33333 - 1).at_beginning_of_hour,
          (DateTime.now - (0.04166*i) - 0.33333 - 1).at_beginning_of_hour
          )
          avg = current.average(:value)
        if(avg)
          hourlyAverageYesterday.push(avg)
        else 
          hourlyAverageYesterday.push("NaN")
        end
      end

      @hourlyAverageYesterday = hourlyAverageYesterday





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

      _startDate = Date.new(_startYear.to_i, _startMonth.to_i, _startDay.to_i)
      _endDate = Date.new(_endYear.to_i, _endMonth.to_i, _endDay.to_i)
      @heartrates = Heartrate.where("device = ? AND created_at > ? AND created_at < ?", @patient, _startDate, _endDate).order(:Time)
    end
  end

  def history
    @patient = params[:id]
    if @patient == nil then
      #if one just goes to the stats page, just show one of the patients. Helps with tests as well.
      @patient = "12345abc"
    end
    @picture = Patient.where(device: @patient).take
  end

  def prescription
    @patient = params[:id]
    if @patient == nil then
      #if one just goes to the stats page, just show one of the patients. Helps with tests as well.
      @patient = "12345abc"
    end
    @picture = Patient.where(device: @patient).take
  end

  def notes
    @patient = params[:id]
    if @patient == nil then
      #if one just goes to the stats page, just show one of the patients. Helps with tests as well.
      @patient = "12345abc"
    end
    @picture = Patient.where(device: @patient).take
  end

  def messaging
    @patient = params[:id]
    if @patient == nil then
      #if one just goes to the stats page, just show one of the patients. Helps with tests as well.
      @patient = "12345abc"
    end
    @picture = Patient.where(device: @patient).take
  end
end