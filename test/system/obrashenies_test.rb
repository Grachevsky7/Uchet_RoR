require "application_system_test_case"

class ObrasheniesTest < ApplicationSystemTestCase
  setup do
    @obrasheny = obrashenies(:one)
  end

  test "visiting the index" do
    visit obrashenies_url
    assert_selector "h1", text: "Obrashenies"
  end

  test "should create obrashenie" do
    visit obrashenies_url
    click_on "New obrashenie"

    fill_in "Data obr", with: @obrasheny.data_obr
    fill_in "Data vypoln obr", with: @obrasheny.data_vypoln_obr
    fill_in "Dok vypoln obr path", with: @obrasheny.dok_vypoln_obr_path
    fill_in "Klient", with: @obrasheny.klient_id
    fill_in "Po", with: @obrasheny.po_id
    check "S delete" if @obrasheny.s_delete
    fill_in "Specialist", with: @obrasheny.specialist_id
    check "Status" if @obrasheny.status
    fill_in "Status obr", with: @obrasheny.status_obr
    fill_in "Tema obr", with: @obrasheny.tema_obr
    click_on "Create Obrashenie"

    assert_text "Obrashenie was successfully created"
    click_on "Back"
  end

  test "should update Obrashenie" do
    visit obrasheny_url(@obrasheny)
    click_on "Edit this obrashenie", match: :first

    fill_in "Data obr", with: @obrasheny.data_obr
    fill_in "Data vypoln obr", with: @obrasheny.data_vypoln_obr
    fill_in "Dok vypoln obr path", with: @obrasheny.dok_vypoln_obr_path
    fill_in "Klient", with: @obrasheny.klient_id
    fill_in "Po", with: @obrasheny.po_id
    check "S delete" if @obrasheny.s_delete
    fill_in "Specialist", with: @obrasheny.specialist_id
    check "Status" if @obrasheny.status
    fill_in "Status obr", with: @obrasheny.status_obr
    fill_in "Tema obr", with: @obrasheny.tema_obr
    click_on "Update Obrashenie"

    assert_text "Obrashenie was successfully updated"
    click_on "Back"
  end

  test "should destroy Obrashenie" do
    visit obrasheny_url(@obrasheny)
    click_on "Destroy this obrashenie", match: :first

    assert_text "Obrashenie was successfully destroyed"
  end
end
