require 'test_helper'

class HeartratesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @heartrate = heartrates(:one)
  end

  test "should get index" do
    get heartrates_url
    assert_response :success
  end

  test "should get new" do
    get new_heartrate_url
    assert_response :success
  end

  test "should create heartrate" do
    assert_difference('Heartrate.count') do
      post heartrates_url, params: { heartrate: { device: @heartrate.device, time: @heartrate.time, value: @heartrate.value } }
    end

    assert_redirected_to heartrate_url(Heartrate.last)
  end

  test "should show heartrate" do
    get heartrate_url(@heartrate)
    assert_response :success
  end

  test "should get edit" do
    get edit_heartrate_url(@heartrate)
    assert_response :success
  end

  test "should update heartrate" do
    patch heartrate_url(@heartrate), params: { heartrate: { device: @heartrate.device, time: @heartrate.time, value: @heartrate.value } }
    assert_redirected_to heartrate_url(@heartrate)
  end

  test "should destroy heartrate" do
    assert_difference('Heartrate.count', -1) do
      delete heartrate_url(@heartrate)
    end

    assert_redirected_to heartrates_url
  end
end
