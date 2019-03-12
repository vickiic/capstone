class StatsController < ApplicationController
  def index
    @patient = params[:id]
    if @patient == nil then
      #if one just goes to the stats page, just show one of the patients. Helps with tests as well.
      @patient = "12345abc"
    end
    @picture = Patient.where(device: @patient).take
    @heartrates = Heartrate.where("device = ?", @patient).order(:Time)

    weekly1 = Array.new(24)
    hourlyTimeToday = Array.new(24)
    validData = Array.new(24)
    (0..23).each do |i|
      (0..6).each do |j|
        current = Heartrate.where("device = ? AND time >= ? AND time <= ?",
          @patient,
          (DateTime.parse("2019-3-14 11:00") - (0.04166*(i+1)) - j).at_beginning_of_hour,
          (DateTime.parse("2019-3-14 11:00") - (0.04166*i) - j).at_beginning_of_hour)
        avg = current.average(:value)
        if(avg)
          validData[i] = validData[i].to_i + 1
          weekly1[i] = weekly1[i].to_i + avg
        end
        if(j == 6 && weekly1[i].to_i != 0)
          weekly1[i] = weekly1[i] / validData[i]
        end
        hourlyTimeToday[i] = (DateTime.parse("2019-3-14 11:00") - (0.0416*i)).at_beginning_of_hour
      end
    end

    @weekly1 = weekly1
    @hourlyTimeToday = hourlyTimeToday

    weekly2 = Array.new(24)
    validData = Array.new(24)
    (0..23).each do |i|
      (0..6).each do |j|
        current = Heartrate.where("device = ? AND time >= ? AND time <= ?",
          @patient,
          (DateTime.parse("2019-3-14 11:00") - (0.04166*(i+1)) - 7 - j).at_beginning_of_hour,
          (DateTime.parse("2019-3-14 11:00") - (0.04166*i) - 7 - j).at_beginning_of_hour
          )
          avg = current.average(:value)
        if(avg)
          validData[i] = validData[i].to_i + 1
          weekly2[i] = weekly2[i].to_i + avg
        end
        if(j == 6 && weekly2[i].to_i != 0)
          weekly2[i] = weekly2[i] / validData[i]
        end
      end
    end

    @weekly2 = weekly2

    weekly3 = Array.new(24)
    validData = Array.new(24)
    (0..23).each do |i|
      (0..6).each do |j|
        current = Heartrate.where("device = ? AND time >= ? AND time <= ?",
          @patient,
          (DateTime.parse("2019-3-14 11:00") - (0.04166*(i+1)) - 14 - j).at_beginning_of_hour,
          (DateTime.parse("2019-3-14 11:00") - (0.04166*i) - 14 - j).at_beginning_of_hour
          )
          avg = current.average(:value)
        if(avg)
          validData[i] = validData[i].to_i + 1
          weekly3[i] = weekly3[i].to_i + avg
        end
        if(j == 6 && weekly3[i].to_i != 0)
          weekly3[i] = weekly3[i] / validData[i]
        end
      end
    end

    @weekly3 = weekly3

    weekly4 = Array.new(24)
    validData = Array.new(24)
    (0..23).each do |i|
      (0..6).each do |j|
        current = Heartrate.where("device = ? AND time >= ? AND time <= ?",
          @patient,
          (DateTime.parse("2019-3-14 11:00") - (0.04166*(i+1)) - 21 - j).at_beginning_of_hour,
          (DateTime.parse("2019-3-14 11:00") - (0.04166*i) - 21 - j).at_beginning_of_hour)
        avg = current.average(:value)
        if(avg)
          validData[i] = validData[i].to_i + 1
          weekly4[i] = weekly4[i].to_i + avg
        end
        if(j == 6 && weekly4[i].to_i != 0)
          weekly4[i] = weekly4[i] / validData[i]
        end
      end
    end

    @weekly4 = weekly4

    hourlyAverageToday = Array.new
    (0..23).each do |i|
      current = Heartrate.where("device = ? AND time >= ? AND time <= ?",
        @patient,
        (DateTime.parse("2019-3-14 11:00") - (0.04166*(i+1))).at_beginning_of_hour,
        (DateTime.parse("2019-3-14 11:00") - (0.04166*i)).at_beginning_of_hour)
      avg = current.average(:value)
      if(avg)
        hourlyAverageToday.push(avg)
      else 
        hourlyAverageToday.push("NaN")
      end
    end

    @hourlyAverageToday = hourlyAverageToday

    @todayRaw = Heartrate.where("device = ? AND time >= ? AND time <= ?",
      @patient,
      DateTime.parse("2019-3-14 11:00") - 1,
      DateTime.parse("2019-3-14 11:00")).order(:Time)


    @allSymptoms = Heartrate.where("device = ? AND symptom != ?", @patient, "").order(:time).reverse_order

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