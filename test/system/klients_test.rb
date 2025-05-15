require "application_system_test_case"

class KlientsTest < ApplicationSystemTestCase
  setup do
    @klient = klients(:one)
  end

  test "visiting the index" do
    visit klients_url
    assert_selector "h1", text: "Klients"
  end

  test "should create klient" do
    visit klients_url
    click_on "New klient"

    fill_in "Adres kl", with: @klient.adres_kl
    fill_in "Kontakt lico", with: @klient.kontakt_lico
    fill_in "Name komp", with: @klient.name_komp
    fill_in "Pochta kl", with: @klient.pochta_kl
    check "S delete" if @klient.s_delete
    check "Status" if @klient.status
    fill_in "Telef kl", with: @klient.telef_kl
    click_on "Create Klient"

    assert_text "Klient was successfully created"
    click_on "Back"
  end

  test "should update Klient" do
    visit klient_url(@klient)
    click_on "Edit this klient", match: :first

    fill_in "Adres kl", with: @klient.adres_kl
    fill_in "Kontakt lico", with: @klient.kontakt_lico
    fill_in "Name komp", with: @klient.name_komp
    fill_in "Pochta kl", with: @klient.pochta_kl
    check "S delete" if @klient.s_delete
    check "Status" if @klient.status
    fill_in "Telef kl", with: @klient.telef_kl
    click_on "Update Klient"

    assert_text "Klient was successfully updated"
    click_on "Back"
  end

  test "should destroy Klient" do
    visit klient_url(@klient)
    click_on "Destroy this klient", match: :first

    assert_text "Klient was successfully destroyed"
  end
end
