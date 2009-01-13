require 'test_helper'

class DocumentTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:document_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create document_type" do
    assert_difference('DocumentType.count') do
      post :create, :document_type => { }
    end

    assert_redirected_to document_type_path(assigns(:document_type))
  end

  test "should show document_type" do
    get :show, :id => document_types(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => document_types(:one).id
    assert_response :success
  end

  test "should update document_type" do
    put :update, :id => document_types(:one).id, :document_type => { }
    assert_redirected_to document_type_path(assigns(:document_type))
  end

  test "should destroy document_type" do
    assert_difference('DocumentType.count', -1) do
      delete :destroy, :id => document_types(:one).id
    end

    assert_redirected_to document_types_path
  end
end
