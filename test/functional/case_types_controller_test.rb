require 'test_helper'

class CaseTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:case_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create case_type" do
    assert_difference('CaseType.count') do
      post :create, :case_type => { }
    end

    assert_redirected_to case_type_path(assigns(:case_type))
  end

  test "should show case_type" do
    get :show, :id => case_types(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => case_types(:one).id
    assert_response :success
  end

  test "should update case_type" do
    put :update, :id => case_types(:one).id, :case_type => { }
    assert_redirected_to case_type_path(assigns(:case_type))
  end

  test "should destroy case_type" do
    assert_difference('CaseType.count', -1) do
      delete :destroy, :id => case_types(:one).id
    end

    assert_redirected_to case_types_path
  end
end
