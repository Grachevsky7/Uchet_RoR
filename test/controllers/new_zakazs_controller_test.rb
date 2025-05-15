require "test_helper"

class NewZakazsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @new_zakaz = new_zakazs(:one)
  end

  test "should get index" do
    get new_zakazs_url
    assert_response :success
  end

  test "should get new" do
    get new_new_zakaz_url
    assert_response :success
  end

  test "should create new_zakaz" do
    assert_difference("NewZakaz.count") do
      post new_zakazs_url, params: { new_zakaz: { chek_opl_zak_path: @new_zakaz.chek_opl_zak_path, data_vypoln_zak: @new_zakaz.data_vypoln_zak, data_zak: @new_zakaz.data_zak, dok_vypoln_zak_path: @new_zakaz.dok_vypoln_zak_path, klient_id: @new_zakaz.klient_id, po_id: @new_zakaz.po_id, s_delete: @new_zakaz.s_delete, specialist_id: @new_zakaz.specialist_id, srok_arendy: @new_zakaz.srok_arendy, stat_zak: @new_zakaz.stat_zak, status: @new_zakaz.status, stoimost_v_god: @new_zakaz.stoimost_v_god, stoimost_zak: @new_zakaz.stoimost_zak, string: @new_zakaz.string } }
    end

    assert_redirected_to new_zakaz_url(NewZakaz.last)
  end

  test "should show new_zakaz" do
    get new_zakaz_url(@new_zakaz)
    assert_response :success
  end

  test "should get edit" do
    get edit_new_zakaz_url(@new_zakaz)
    assert_response :success
  end

  test "should update new_zakaz" do
    patch new_zakaz_url(@new_zakaz), params: { new_zakaz: { chek_opl_zak_path: @new_zakaz.chek_opl_zak_path, data_vypoln_zak: @new_zakaz.data_vypoln_zak, data_zak: @new_zakaz.data_zak, dok_vypoln_zak_path: @new_zakaz.dok_vypoln_zak_path, klient_id: @new_zakaz.klient_id, po_id: @new_zakaz.po_id, s_delete: @new_zakaz.s_delete, specialist_id: @new_zakaz.specialist_id, srok_arendy: @new_zakaz.srok_arendy, stat_zak: @new_zakaz.stat_zak, status: @new_zakaz.status, stoimost_v_god: @new_zakaz.stoimost_v_god, stoimost_zak: @new_zakaz.stoimost_zak, string: @new_zakaz.string } }
    assert_redirected_to new_zakaz_url(@new_zakaz)
  end

  test "should destroy new_zakaz" do
    assert_difference("NewZakaz.count", -1) do
      delete new_zakaz_url(@new_zakaz)
    end

    assert_redirected_to new_zakazs_url
  end
end
