require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get welcome_index_url
    assert_equal(assigns(:search), "")
    assert_response :success
  end

  test "should get index with search" do
    get welcome_index_url(searchInput: "iOS")
    assert_equal(assigns(:search), "iOS")
    assert_response :success
  end

end
