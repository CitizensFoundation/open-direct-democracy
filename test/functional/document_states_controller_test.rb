require 'test_helper'

class DocumentStatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:document_states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create document_state" do
    assert_difference('DocumentState.count') do
      post :create, :document_state => { }
    end

    assert_redirected_to document_state_path(assigns(:document_state))
  end

  test "should show document_state" do
    get :show, :id => document_states(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => document_states(:one).id
    assert_response :success
  end

  test "should update document_state" do
    put :update, :id => document_states(:one).id, :document_state => { }
    assert_redirected_to document_state_path(assigns(:document_state))
  end

  test "should destroy document_state" do
    assert_difference('DocumentState.count', -1) do
      delete :destroy, :id => document_states(:one).id
    end

    assert_redirected_to document_states_path
  end
end
