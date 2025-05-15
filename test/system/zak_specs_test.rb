require "application_system_test_case"

class ZakSpecsTest < ApplicationSystemTestCase
  setup do
    @zak_spec = zak_specs(:one)
  end

  test "visiting the index" do
    visit zak_specs_url
    assert_selector "h1", text: "Zak specs"
  end

  test "should create zak spec" do
    visit zak_specs_url
    click_on "New zak spec"

    fill_in "Description", with: @zak_spec.description
    fill_in "Name", with: @zak_spec.name
    click_on "Create Zak spec"

    assert_text "Zak spec was successfully created"
    click_on "Back"
  end

  test "should update Zak spec" do
    visit zak_spec_url(@zak_spec)
    click_on "Edit this zak spec", match: :first

    fill_in "Description", with: @zak_spec.description
    fill_in "Name", with: @zak_spec.name
    click_on "Update Zak spec"

    assert_text "Zak spec was successfully updated"
    click_on "Back"
  end

  test "should destroy Zak spec" do
    visit zak_spec_url(@zak_spec)
    click_on "Destroy this zak spec", match: :first

    assert_text "Zak spec was successfully destroyed"
  end
end
