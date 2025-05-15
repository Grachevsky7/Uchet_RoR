require "application_system_test_case"

class SpecialistsTest < ApplicationSystemTestCase
  setup do
    @specialist = specialists(:one)
  end

  test "visiting the index" do
    visit specialists_url
    assert_selector "h1", text: "Specialists"
  end

  test "should create specialist" do
    visit specialists_url
    click_on "New specialist"

    fill_in "Dlzhnst spec", with: @specialist.dlzhnst_spec
    fill_in "Fio spec", with: @specialist.fio_spec
    fill_in "Pochta spec", with: @specialist.pochta_spec
    check "S delete" if @specialist.s_delete
    check "Status" if @specialist.status
    fill_in "Status spec", with: @specialist.status_spec
    fill_in "Telef spec", with: @specialist.telef_spec
    click_on "Create Specialist"

    assert_text "Specialist was successfully created"
    click_on "Back"
  end

  test "should update Specialist" do
    visit specialist_url(@specialist)
    click_on "Edit this specialist", match: :first

    fill_in "Dlzhnst spec", with: @specialist.dlzhnst_spec
    fill_in "Fio spec", with: @specialist.fio_spec
    fill_in "Pochta spec", with: @specialist.pochta_spec
    check "S delete" if @specialist.s_delete
    check "Status" if @specialist.status
    fill_in "Status spec", with: @specialist.status_spec
    fill_in "Telef spec", with: @specialist.telef_spec
    click_on "Update Specialist"

    assert_text "Specialist was successfully updated"
    click_on "Back"
  end

  test "should destroy Specialist" do
    visit specialist_url(@specialist)
    click_on "Destroy this specialist", match: :first

    assert_text "Specialist was successfully destroyed"
  end
end
