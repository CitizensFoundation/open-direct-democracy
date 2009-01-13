require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:issues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create issue" do
    assert_difference('Issue.count') do
      post :create, :issue => { }
    end

    assert_redirected_to issue_path(assigns(:issue))
  end

  test "should show issue" do
    get :show, :id => issues(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => issues(:one).id
    assert_response :success
  end

  test "should update issue" do
    put :update, :id => issues(:one).id, :issue => { }
    assert_redirected_to issue_path(assigns(:issue))
  end

  test "should destroy issue" do
    assert_difference('Issue.count', -1) do
      delete :destroy, :id => issues(:one).id
    end

    assert_redirected_to issues_path
  end
end
