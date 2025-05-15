require "application_system_test_case"

class NewZakazsTest < ApplicationSystemTestCase
  setup do
    @new_zakaz = new_zakazs(:one)
  end

  test "visiting the index" do
    visit new_zakazs_url
    assert_selector "h1", text: "New zakazs"
  end

  test "should create new zakaz" do
    visit new_zakazs_url
    click_on "New new zakaz"

    fill_in "Chek opl zak path", with: @new_zakaz.chek_opl_zak_path
    fill_in "Data vypoln zak", with: @new_zakaz.data_vypoln_zak
    fill_in "Data zak", with: @new_zakaz.data_zak
    fill_in "Dok vypoln zak path", with: @new_zakaz.dok_vypoln_zak_path
    fill_in "Klient", with: @new_zakaz.klient_id
    fill_in "Po", with: @new_zakaz.po_id
    check "S delete" if @new_zakaz.s_delete
    fill_in "Specialist", with: @new_zakaz.specialist_id
    fill_in "Srok arendy", with: @new_zakaz.srok_arendy
    fill_in "Stat zak", with: @new_zakaz.stat_zak
    check "Status" if @new_zakaz.status
    fill_in "Stoimost v god", with: @new_zakaz.stoimost_v_god
    fill_in "Stoimost zak", with: @new_zakaz.stoimost_zak
    fill_in "String", with: @new_zakaz.string
    click_on "Create New zakaz"

    assert_text "New zakaz was successfully created"
    click_on "Back"
  end

  test "should update New zakaz" do
    visit new_zakaz_url(@new_zakaz)
    click_on "Edit this new zakaz", match: :first

    fill_in "Chek opl zak path", with: @new_zakaz.chek_opl_zak_path
    fill_in "Data vypoln zak", with: @new_zakaz.data_vypoln_zak
    fill_in "Data zak", with: @new_zakaz.data_zak
    fill_in "Dok vypoln zak path", with: @new_zakaz.dok_vypoln_zak_path
    fill_in "Klient", with: @new_zakaz.klient_id
    fill_in "Po", with: @new_zakaz.po_id
    check "S delete" if @new_zakaz.s_delete
    fill_in "Specialist", with: @new_zakaz.specialist_id
    fill_in "Srok arendy", with: @new_zakaz.srok_arendy
    fill_in "Stat zak", with: @new_zakaz.stat_zak
    check "Status" if @new_zakaz.status
    fill_in "Stoimost v god", with: @new_zakaz.stoimost_v_god
    fill_in "Stoimost zak", with: @new_zakaz.stoimost_zak
    fill_in "String", with: @new_zakaz.string
    click_on "Update New zakaz"

    assert_text "New zakaz was successfully updated"
    click_on "Back"
  end

  test "should destroy New zakaz" do
    visit new_zakaz_url(@new_zakaz)
    click_on "Destroy this new zakaz", match: :first

    assert_text "New zakaz was successfully destroyed"
  end
end
