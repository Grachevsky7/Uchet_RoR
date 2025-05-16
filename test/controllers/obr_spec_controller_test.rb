require "test_helper"

class ObrSpecControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get obr_spec_index_url
    assert_response :success
  end
end
