require "application_system_test_case"

class PosTest < ApplicationSystemTestCase
  setup do
    @po = pos(:one)
  end

  test "visiting the index" do
    visit pos_url
    assert_selector "h1", text: "Pos"
  end

  test "should create po" do
    visit pos_url
    click_on "New po"

    fill_in "Data vypuska po", with: @po.data_vypuska_po
    fill_in "Name po", with: @po.name_po
    check "S delete" if @po.s_delete
    check "Status" if @po.status
    fill_in "Stoimost po", with: @po.stoimost_po
    fill_in "Vers po", with: @po.vers_po
    click_on "Create Po"

    assert_text "Po was successfully created"
    click_on "Back"
  end

  test "should update Po" do
    visit po_url(@po)
    click_on "Edit this po", match: :first

    fill_in "Data vypuska po", with: @po.data_vypuska_po
    fill_in "Name po", with: @po.name_po
    check "S delete" if @po.s_delete
    check "Status" if @po.status
    fill_in "Stoimost po", with: @po.stoimost_po
    fill_in "Vers po", with: @po.vers_po
    click_on "Update Po"

    assert_text "Po was successfully updated"
    click_on "Back"
  end

  test "should destroy Po" do
    visit po_url(@po)
    click_on "Destroy this po", match: :first

    assert_text "Po was successfully destroyed"
  end
end
