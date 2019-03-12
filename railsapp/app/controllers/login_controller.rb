class LoginController < ApplicationController
  
  
  def index
    @invalid = !(params[:invalid] == nil)
  end
  def authenticate
    target = [[80, 80, 75, 60, 62, 64, 66, 68, 70, 70, 70, 70, 75, 95, 120, 90, 75, 75, 80, 80, 75, 75, 80, 80],
              [80, 80, 75, 60, 62, 64, 66, 68, 70, 70, 70, 70, 75, 95, 120, 90, 75, 75, 80, 80, 75, 75, 80, 80],
              [80, 80, 75, 60, 62, 64, 66, 68, 70, 70, 70, 70, 75, 75, 80, 80, 75, 75, 80, 90, 120, 95, 80, 80],
              [80, 80, 75, 60, 62, 64, 66, 68, 70, 70, 70, 70, 75, 75, 80, 80, 75, 75, 80, 90, 130, 95, 80, 80]]

    newData = []
    (0..40).each do |i|
      newData.push({})
      randHour = rand(24)
      randWeek = 0
      newData[i][:device] = 'demo'
      newData[i][:value] = target[randWeek][randHour] + rand(10) - 5
      randomTime = DateTime.parse("2019-3-14 11:00") - randHour / 24.0 - rand() / 24.0
      newData[i][:time] = randomTime.strftime("%Y-%m-%d %H:%M:%S.00")
    end
    Heartrate.create(newData)

    redirect_to login_index_path
  end

  def gen
    target = [[80, 80, 75, 60, 62, 64, 66, 68, 70, 70, 70, 70, 75, 95, 120, 90, 75, 75, 80, 80, 75, 75, 80, 80],
              [80, 80, 75, 60, 62, 64, 66, 68, 70, 70, 70, 70, 75, 95, 120, 90, 75, 75, 80, 80, 75, 75, 80, 80],
              [80, 80, 75, 60, 62, 64, 66, 68, 70, 70, 70, 70, 75, 75, 80, 80, 75, 75, 80, 90, 120, 95, 80, 80],
              [80, 80, 75, 60, 62, 64, 66, 68, 70, 70, 70, 70, 75, 75, 80, 80, 75, 75, 80, 90, 130, 95, 80, 80]]

    newData = []
    (0..200).each do |i|
      newData.push({})
      randHour = rand(24)
      randWeek = rand(4)
      newData[i][:device] = 'demo'
      newData[i][:value] = target[randWeek][randHour] + rand(20) - 10
      randomTime = DateTime.parse("2019-3-14 11:00") - randHour / 24.0 - rand() / 24.0 - randWeek*7 - rand(7)
      newData[i][:time] = randomTime.strftime("%Y-%m-%d %H:%M:%S.00")
    end
    Heartrate.create(newData)
    redirect_to login_index_path
  end

  def clearDb
    Heartrate.where("device = ?", "demo").delete_all
    redirect_to login_index_path
  end
end

