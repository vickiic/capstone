require 'test_helper'

class StatsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stats_index_url
    assert_equal(assigns(:patient), "12345abc")
    assert_response :success
  end

  test "should get index with patient param" do
    get stats_index_url(id: "hzr3Pbi4Q9XrV7top1N9JAIPy3h1")
    assert_equal(assigns(:patient), "hzr3Pbi4Q9XrV7top1N9JAIPy3h1")
    assert_response :success
  end

  test "should get index with date params 1" do
    get stats_index_url(id: "hzr3Pbi4Q9XrV7top1N9JAIPy3h1",
                        commit: "Submit",
                        startYear: "2000",
                        startMonth: "12",
                        startDay: "2")
    assert_equal(assigns(:patient), "hzr3Pbi4Q9XrV7top1N9JAIPy3h1")
    assert_equal(assigns(:startYear), "2000")
    assert_equal(assigns(:startMonth), "12")
    assert_equal(assigns(:startDay), "02")
    assert_equal(assigns(:endYear), Time.now.strftime("%Y"))
    assert_equal(assigns(:endMonth), Time.now.strftime("%m"))
    assert_equal(assigns(:endDay), Time.now.strftime("%d"))


    assert_response :success
  end

end
