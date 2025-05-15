require "test_helper"

class ZakSpecsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @zak_spec = zak_specs(:one)
  end

  test "should get index" do
    get zak_specs_url
    assert_response :success
  end

  test "should get new" do
    get new_zak_spec_url
    assert_response :success
  end

  test "should create zak_spec" do
    assert_difference("ZakSpec.count") do
      post zak_specs_url, params: { zak_spec: { description: @zak_spec.description, name: @zak_spec.name } }
    end

    assert_redirected_to zak_spec_url(ZakSpec.last)
  end

  test "should show zak_spec" do
    get zak_spec_url(@zak_spec)
    assert_response :success
  end

  test "should get edit" do
    get edit_zak_spec_url(@zak_spec)
    assert_response :success
  end

  test "should update zak_spec" do
    patch zak_spec_url(@zak_spec), params: { zak_spec: { description: @zak_spec.description, name: @zak_spec.name } }
    assert_redirected_to zak_spec_url(@zak_spec)
  end

  test "should destroy zak_spec" do
    assert_difference("ZakSpec.count", -1) do
      delete zak_spec_url(@zak_spec)
    end

    assert_redirected_to zak_specs_url
  end
end
