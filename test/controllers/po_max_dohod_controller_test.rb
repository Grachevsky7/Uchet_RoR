require "test_helper"

class PoMaxDohodControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get po_max_dohod_index_url
    assert_response :success
  end
end
