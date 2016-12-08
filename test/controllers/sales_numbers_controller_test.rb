require 'test_helper'

class SalesNumbersControllerTest < ActionController::TestCase
  setup do
    @sales_number = sales_numbers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_numbers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_number" do
    assert_difference('SalesNumber.count') do
      post :create, sales_number: { name: @sales_number.name, number: @sales_number.number }
    end

    assert_redirected_to sales_number_path(assigns(:sales_number))
  end

  test "should show sales_number" do
    get :show, id: @sales_number
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_number
    assert_response :success
  end

  test "should update sales_number" do
    patch :update, id: @sales_number, sales_number: { name: @sales_number.name, number: @sales_number.number }
    assert_redirected_to sales_number_path(assigns(:sales_number))
  end

  test "should destroy sales_number" do
    assert_difference('SalesNumber.count', -1) do
      delete :destroy, id: @sales_number
    end

    assert_redirected_to sales_numbers_path
  end
end
