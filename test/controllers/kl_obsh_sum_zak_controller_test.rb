require "test_helper"

class KlObshSumZakControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kl_obsh_sum_zak_index_url
    assert_response :success
  end
end
