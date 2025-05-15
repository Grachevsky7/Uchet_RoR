require "test_helper"

class ZakazsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @zakaz = zakazs(:one)
  end

  test "should get index" do
    get zakazs_url
    assert_response :success
  end

  test "should get new" do
    get new_zakaz_url
    assert_response :success
  end

  test "should create zakaz" do
    assert_difference("Zakaz.count") do
      post zakazs_url, params: { zakaz: { chek_opl_zak_path: @zakaz.chek_opl_zak_path, data_vypoln_zak: @zakaz.data_vypoln_zak, data_zak: @zakaz.data_zak, dok_vypoln_zak_path: @zakaz.dok_vypoln_zak_path, klient_id: @zakaz.klient_id, po_id: @zakaz.po_id, s_delete: @zakaz.s_delete, specialist_id: @zakaz.specialist_id, stat_zak: @zakaz.stat_zak, status: @zakaz.status, stoimost_zak: @zakaz.stoimost_zak } }
    end

    assert_redirected_to zakaz_url(Zakaz.last)
  end

  test "should show zakaz" do
    get zakaz_url(@zakaz)
    assert_response :success
  end

  test "should get edit" do
    get edit_zakaz_url(@zakaz)
    assert_response :success
  end

  test "should update zakaz" do
    patch zakaz_url(@zakaz), params: { zakaz: { chek_opl_zak_path: @zakaz.chek_opl_zak_path, data_vypoln_zak: @zakaz.data_vypoln_zak, data_zak: @zakaz.data_zak, dok_vypoln_zak_path: @zakaz.dok_vypoln_zak_path, klient_id: @zakaz.klient_id, po_id: @zakaz.po_id, s_delete: @zakaz.s_delete, specialist_id: @zakaz.specialist_id, stat_zak: @zakaz.stat_zak, status: @zakaz.status, stoimost_zak: @zakaz.stoimost_zak } }
    assert_redirected_to zakaz_url(@zakaz)
  end

  test "should destroy zakaz" do
    assert_difference("Zakaz.count", -1) do
      delete zakaz_url(@zakaz)
    end

    assert_redirected_to zakazs_url
  end
end
