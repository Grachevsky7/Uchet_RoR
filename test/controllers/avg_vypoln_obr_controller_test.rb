require "test_helper"

class AvgVypolnObrControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get avg_vypoln_obr_index_url
    assert_response :success
  end
end
