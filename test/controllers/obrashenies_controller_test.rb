require "test_helper"

class ObrasheniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @obrasheny = obrashenies(:one)
  end

  test "should get index" do
    get obrashenies_url
    assert_response :success
  end

  test "should get new" do
    get new_obrasheny_url
    assert_response :success
  end

  test "should create obrasheny" do
    assert_difference("Obrashenie.count") do
      post obrashenies_url, params: { obrasheny: { data_obr: @obrasheny.data_obr, data_vypoln_obr: @obrasheny.data_vypoln_obr, dok_vypoln_obr_path: @obrasheny.dok_vypoln_obr_path, klient_id: @obrasheny.klient_id, po_id: @obrasheny.po_id, s_delete: @obrasheny.s_delete, specialist_id: @obrasheny.specialist_id, status: @obrasheny.status, status_obr: @obrasheny.status_obr, tema_obr: @obrasheny.tema_obr } }
    end

    assert_redirected_to obrasheny_url(Obrashenie.last)
  end

  test "should show obrasheny" do
    get obrasheny_url(@obrasheny)
    assert_response :success
  end

  test "should get edit" do
    get edit_obrasheny_url(@obrasheny)
    assert_response :success
  end

  test "should update obrasheny" do
    patch obrasheny_url(@obrasheny), params: { obrasheny: { data_obr: @obrasheny.data_obr, data_vypoln_obr: @obrasheny.data_vypoln_obr, dok_vypoln_obr_path: @obrasheny.dok_vypoln_obr_path, klient_id: @obrasheny.klient_id, po_id: @obrasheny.po_id, s_delete: @obrasheny.s_delete, specialist_id: @obrasheny.specialist_id, status: @obrasheny.status, status_obr: @obrasheny.status_obr, tema_obr: @obrasheny.tema_obr } }
    assert_redirected_to obrasheny_url(@obrasheny)
  end

  test "should destroy obrasheny" do
    assert_difference("Obrashenie.count", -1) do
      delete obrasheny_url(@obrasheny)
    end

    assert_redirected_to obrashenies_url
  end
end
