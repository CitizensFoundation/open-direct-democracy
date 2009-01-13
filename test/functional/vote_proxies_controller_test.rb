require 'test_helper'

class VoteProxiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vote_proxies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vote_proxy" do
    assert_difference('VoteProxy.count') do
      post :create, :vote_proxy => { }
    end

    assert_redirected_to vote_proxy_path(assigns(:vote_proxy))
  end

  test "should show vote_proxy" do
    get :show, :id => vote_proxies(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => vote_proxies(:one).id
    assert_response :success
  end

  test "should update vote_proxy" do
    put :update, :id => vote_proxies(:one).id, :vote_proxy => { }
    assert_redirected_to vote_proxy_path(assigns(:vote_proxy))
  end

  test "should destroy vote_proxy" do
    assert_difference('VoteProxy.count', -1) do
      delete :destroy, :id => vote_proxies(:one).id
    end

    assert_redirected_to vote_proxies_path
  end
end
