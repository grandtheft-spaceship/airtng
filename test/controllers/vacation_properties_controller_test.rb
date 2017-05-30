require 'test_helper'

class VacationPropertiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vacation_property = vacation_properties(:one)
  end

  test "should get index" do
    get vacation_properties_url
    assert_response :success
  end

  test "should get new" do
    get new_vacation_property_url
    assert_response :success
  end

  test "should create vacation_property" do
    assert_difference('VacationProperty.count') do
      post vacation_properties_url, params: { vacation_property: { description: @vacation_property.description, image_url: @vacation_property.image_url } }
    end

    assert_redirected_to vacation_property_url(VacationProperty.last)
  end

  test "should show vacation_property" do
    get vacation_property_url(@vacation_property)
    assert_response :success
  end

  test "should get edit" do
    get edit_vacation_property_url(@vacation_property)
    assert_response :success
  end

  test "should update vacation_property" do
    patch vacation_property_url(@vacation_property), params: { vacation_property: { description: @vacation_property.description, image_url: @vacation_property.image_url } }
    assert_redirected_to vacation_property_url(@vacation_property)
  end

  test "should destroy vacation_property" do
    assert_difference('VacationProperty.count', -1) do
      delete vacation_property_url(@vacation_property)
    end

    assert_redirected_to vacation_properties_url
  end
end
