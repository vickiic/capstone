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
    target = [[70, 68, 66, 64, 62, 60, 58, 56, 70, 80, 85, 85, 100, 85, 85, 85, 85, 85, 85, 85, 80, 80, 75, 75],
              [70, 68, 66, 64, 62, 60, 58, 56, 70, 80, 85, 85, 100, 85, 85, 85, 85, 85, 85, 85, 80, 80, 75, 75],
              [80, 75, 70, 64, 62, 60, 58, 56, 70, 80, 85, 85, 85, 85, 85, 85, 85, 85, 85, 100, 80, 80, 80, 80],
              [80, 75, 70, 64, 62, 60, 58, 56, 70, 80, 85, 85, 85, 85, 85, 85, 85, 85, 85, 100, 80, 80, 80, 80]]

    newData = []
    (0..200).each do |i|
      newData.push({})
      randHour = rand(24)
      randWeek = rand(4)
      newData[i][:device] = 'demo'
      newData[i][:value] = target[randWeek][randHour] + rand(20) - 10
      randomTime = DateTime.parse("2019-3-14") - randHour / 24.0 - rand() / 24.0 - randWeek*7 - rand(7)
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

