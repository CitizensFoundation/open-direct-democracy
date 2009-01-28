require 'test_helper'

class CaseSpeechVideosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:case_speech_videos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create case_speech_video" do
    assert_difference('CaseSpeechVideo.count') do
      post :create, :case_speech_video => { }
    end

    assert_redirected_to case_speech_video_path(assigns(:case_speech_video))
  end

  test "should show case_speech_video" do
    get :show, :id => case_speech_videos(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => case_speech_videos(:one).id
    assert_response :success
  end

  test "should update case_speech_video" do
    put :update, :id => case_speech_videos(:one).id, :case_speech_video => { }
    assert_redirected_to case_speech_video_path(assigns(:case_speech_video))
  end

  test "should destroy case_speech_video" do
    assert_difference('CaseSpeechVideo.count', -1) do
      delete :destroy, :id => case_speech_videos(:one).id
    end

    assert_redirected_to case_speech_videos_path
  end
end
