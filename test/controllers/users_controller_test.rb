require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get all" do
    get users_all_url
    assert_response :success
  end
end
