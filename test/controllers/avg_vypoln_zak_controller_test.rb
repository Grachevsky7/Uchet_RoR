require "test_helper"

class AvgVypolnZakControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get avg_vypoln_zak_index_url
    assert_response :success
  end
end
