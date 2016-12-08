require 'test_helper'

class SupportNumbersControllerTest < ActionController::TestCase
  setup do
    @support_number = support_numbers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:support_numbers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create support_number" do
    assert_difference('SupportNumber.count') do
      post :create, support_number: { name: @support_number.name, number: @support_number.number }
    end

    assert_redirected_to support_number_path(assigns(:support_number))
  end

  test "should show support_number" do
    get :show, id: @support_number
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @support_number
    assert_response :success
  end

  test "should update support_number" do
    patch :update, id: @support_number, support_number: { name: @support_number.name, number: @support_number.number }
    assert_redirected_to support_number_path(assigns(:support_number))
  end

  test "should destroy support_number" do
    assert_difference('SupportNumber.count', -1) do
      delete :destroy, id: @support_number
    end

    assert_redirected_to support_numbers_path
  end
end
