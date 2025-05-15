require "test_helper"

class KlientControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get klient_index_url
    assert_response :success
  end
end
