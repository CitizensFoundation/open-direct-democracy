require 'test_helper'

class DocumentCommentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:document_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create document_comment" do
    assert_difference('DocumentComment.count') do
      post :create, :document_comment => { }
    end

    assert_redirected_to document_comment_path(assigns(:document_comment))
  end

  test "should show document_comment" do
    get :show, :id => document_comments(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => document_comments(:one).id
    assert_response :success
  end

  test "should update document_comment" do
    put :update, :id => document_comments(:one).id, :document_comment => { }
    assert_redirected_to document_comment_path(assigns(:document_comment))
  end

  test "should destroy document_comment" do
    assert_difference('DocumentComment.count', -1) do
      delete :destroy, :id => document_comments(:one).id
    end

    assert_redirected_to document_comments_path
  end
end
