class HeartratesController < ApplicationController
  before_action :set_heartrate, only: [:show, :edit, :update, :destroy]

  # GET /heartrates
  # GET /heartrates.json
  def index
    @heartrates = Heartrate.all
  end

  # GET /heartrates/1
  # GET /heartrates/1.json
  def show
  end

  # GET /heartrates/new
  def new
    @heartrate = Heartrate.new
  end

  # GET /heartrates/1/edit
  def edit
  end

  # POST /heartrates
  # POST /heartrates.json
  def create
    _device = params[:device]
    _value = params[:value]
    _time = params[:time]

    exists = Heartrate.where("device = ? AND value = ? AND time = ?", _device, _value, _time)
    if(exists.exists?)
      return
    end

    _lastHeartrate = Heartrate.where("device = ?", _device).last
    if(_lastHeartrate.created_at > DateTime.now - 0.02 && _lastHeartrate.value == _value)
      return
    end

    @heartrate = Heartrate.new(heartrate_params)

    respond_to do |format|
      if @heartrate.save
        format.html { redirect_to @heartrate, notice: 'Heartrate was successfully created.' }
        format.json { render :show, status: :created, location: @heartrate }
      else
        format.html { render :new }
        format.json { render json: @heartrate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /heartrates/1
  # PATCH/PUT /heartrates/1.json
  def update
    respond_to do |format|
      if @heartrate.update(heartrate_params)
        format.html { redirect_to @heartrate, notice: 'Heartrate was successfully updated.' }
        format.json { render :show, status: :ok, location: @heartrate }
      else
        format.html { render :edit }
        format.json { render json: @heartrate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /heartrates/1
  # DELETE /heartrates/1.json
  def destroy
    @heartrate.destroy
    respond_to do |format|
      format.html { redirect_to heartrates_url, notice: 'Heartrate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #/heartrates/device
  def device
    connection = SQLite3::Database.new 'db/development.sqlite3'
    connection.results_as_hash = true
    devices = connection.execute("SELECT DISTINCT device FROM heartrates")
    render 'heartrates/device', locals: {devices: devices}
  end

  #/heartrates/graph:id
  def graph
    connection = SQLite3::Database.new 'db/development.sqlite3'
    connection.results_as_hash = true

    heartrates = connection.execute("SELECT * FROM heartrates WHERE heartrates.device = ?", params['id'])
    render 'heartrates/graph', locals: {heartrates: heartrates, deviceID: 'device:'+params['id']}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_heartrate
      @heartrate = Heartrate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def heartrate_params
      params.require(:heartrate).permit(:device, :value, :time)
    end
end
