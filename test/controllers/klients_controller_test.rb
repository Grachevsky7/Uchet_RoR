require "test_helper"

class KlientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @klient = klients(:one)
  end

  test "should get index" do
    get klients_url
    assert_response :success
  end

  test "should get new" do
    get new_klient_url
    assert_response :success
  end

  test "should create klient" do
    assert_difference("Klient.count") do
      post klients_url, params: { klient: { adres_kl: @klient.adres_kl, kontakt_lico: @klient.kontakt_lico, name_komp: @klient.name_komp, pochta_kl: @klient.pochta_kl, s_delete: @klient.s_delete, status: @klient.status, telef_kl: @klient.telef_kl } }
    end

    assert_redirected_to klient_url(Klient.last)
  end

  test "should show klient" do
    get klient_url(@klient)
    assert_response :success
  end

  test "should get edit" do
    get edit_klient_url(@klient)
    assert_response :success
  end

  test "should update klient" do
    patch klient_url(@klient), params: { klient: { adres_kl: @klient.adres_kl, kontakt_lico: @klient.kontakt_lico, name_komp: @klient.name_komp, pochta_kl: @klient.pochta_kl, s_delete: @klient.s_delete, status: @klient.status, telef_kl: @klient.telef_kl } }
    assert_redirected_to klient_url(@klient)
  end

  test "should destroy klient" do
    assert_difference("Klient.count", -1) do
      delete klient_url(@klient)
    end

    assert_redirected_to klients_url
  end
end
