require "application_system_test_case"

class ZakazsTest < ApplicationSystemTestCase
  setup do
    @zakaz = zakazs(:one)
  end

  test "visiting the index" do
    visit zakazs_url
    assert_selector "h1", text: "Zakazs"
  end

  test "should create zakaz" do
    visit zakazs_url
    click_on "New zakaz"

    fill_in "Chek opl zak path", with: @zakaz.chek_opl_zak_path
    fill_in "Data vypoln zak", with: @zakaz.data_vypoln_zak
    fill_in "Data zak", with: @zakaz.data_zak
    fill_in "Dok vypoln zak path", with: @zakaz.dok_vypoln_zak_path
    fill_in "Klient", with: @zakaz.klient_id
    fill_in "Po", with: @zakaz.po_id
    check "S delete" if @zakaz.s_delete
    fill_in "Specialist", with: @zakaz.specialist_id
    fill_in "Stat zak", with: @zakaz.stat_zak
    check "Status" if @zakaz.status
    fill_in "Stoimost zak", with: @zakaz.stoimost_zak
    click_on "Create Zakaz"

    assert_text "Zakaz was successfully created"
    click_on "Back"
  end

  test "should update Zakaz" do
    visit zakaz_url(@zakaz)
    click_on "Edit this zakaz", match: :first

    fill_in "Chek opl zak path", with: @zakaz.chek_opl_zak_path
    fill_in "Data vypoln zak", with: @zakaz.data_vypoln_zak
    fill_in "Data zak", with: @zakaz.data_zak
    fill_in "Dok vypoln zak path", with: @zakaz.dok_vypoln_zak_path
    fill_in "Klient", with: @zakaz.klient_id
    fill_in "Po", with: @zakaz.po_id
    check "S delete" if @zakaz.s_delete
    fill_in "Specialist", with: @zakaz.specialist_id
    fill_in "Stat zak", with: @zakaz.stat_zak
    check "Status" if @zakaz.status
    fill_in "Stoimost zak", with: @zakaz.stoimost_zak
    click_on "Update Zakaz"

    assert_text "Zakaz was successfully updated"
    click_on "Back"
  end

  test "should destroy Zakaz" do
    visit zakaz_url(@zakaz)
    click_on "Destroy this zakaz", match: :first

    assert_text "Zakaz was successfully destroyed"
  end
end
