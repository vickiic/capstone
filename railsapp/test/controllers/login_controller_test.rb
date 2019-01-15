require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get login_index_url
    assert_response :success
  end

  test "should get authenticate incorrectly" do
    get login_authenticate_url
    assert_redirected_to login_index_path(incorrect: true)
  end

  test "should get authenticate correctly" do
    get login_authenticate_url(q: "admin")
    assert_redirected_to welcome_index_path(param_1: "admin")
  end
end
