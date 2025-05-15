require "test_helper"

class PoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get po_index_url
    assert_response :success
  end

  test "should get search" do
    get po_search_url
    assert_response :success
  end
end
