require 'test_helper'

class CaseDocumentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:case_documents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create case_document_element" do
    assert_difference('CaseDocuments.count') do
      post :create, :case_document_element => { }
    end

    assert_redirected_to case_document_element_path(assigns(:case_document_element))
  end

  test "should show case_document_element" do
    get :show, :id => case_documents(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => case_documents(:one).id
    assert_response :success
  end

  test "should update case_document_element" do
    put :update, :id => case_documents(:one).id, :case_document_element => { }
    assert_redirected_to case_document_element_path(assigns(:case_document_element))
  end

  test "should destroy case_document_element" do
    assert_difference('CaseDocuments.count', -1) do
      delete :destroy, :id => case_documents(:one).id
    end

    assert_redirected_to case_documents_path
  end
end
