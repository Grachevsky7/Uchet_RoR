require "test_helper"

class ObshSummaZakControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get obsh_summa_zak_index_url
    assert_response :success
  end
end
