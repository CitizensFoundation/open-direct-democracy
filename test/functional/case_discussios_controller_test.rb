require 'test_helper'

class CaseDiscussionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:case_discussionss)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create case_discussions" do
    assert_difference('CaseDiscussion.count') do
      post :create, :case_discussions => { }
    end

    assert_redirected_to case_discussions_path(assigns(:case_discussions))
  end

  test "should show case_discussions" do
    get :show, :id => case_discussionss(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => case_discussionss(:one).id
    assert_response :success
  end

  test "should update case_discussions" do
    put :update, :id => case_discussionss(:one).id, :case_discussions => { }
    assert_redirected_to case_discussions_path(assigns(:case_discussions))
  end

  test "should destroy case_discussions" do
    assert_difference('CaseDiscussion.count', -1) do
      delete :destroy, :id => case_discussionss(:one).id
    end

    assert_redirected_to case_discussionss_path
  end
end
