require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get logout" do
    get pages_logout_url
    assert_response :success
  end
end
