require "test_helper"

class NovelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get novels_index_path
    assert_response :success
  end

  test "should get show" do
    post novels_path
    assert_response :success
  end

  test "should get new" do
    get novels_new_url
    assert_response :success
  end

  test "should get create" do
    get novels_create_url
    assert_response :success
  end
end
