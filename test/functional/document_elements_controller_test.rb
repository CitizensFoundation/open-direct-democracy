require 'test_helper'

class DocumentElementsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:document_elements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create document_element" do
    assert_difference('DocumentElement.count') do
      post :create, :document_element => { }
    end

    assert_redirected_to document_element_path(assigns(:document_element))
  end

  test "should show document_element" do
    get :show, :id => document_elements(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => document_elements(:one).id
    assert_response :success
  end

  test "should update document_element" do
    put :update, :id => document_elements(:one).id, :document_element => { }
    assert_redirected_to document_element_path(assigns(:document_element))
  end

  test "should destroy document_element" do
    assert_difference('DocumentElement.count', -1) do
      delete :destroy, :id => document_elements(:one).id
    end

    assert_redirected_to document_elements_path
  end
end
