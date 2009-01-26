class CaseSpeechMasterVideosController < ApplicationController
  # GET /case_speech_master_videos
  # GET /case_speech_master_videos.xml
  def index
    @case_speech_master_videos = CaseSpeechMasterVideo.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @case_speech_master_videos }
    end
  end

  # GET /case_speech_master_videos/1
  # GET /case_speech_master_videos/1.xml
  def show
    @case_speech_master_video = CaseSpeechMasterVideo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @case_speech_master_video }
    end
  end

  # GET /case_speech_master_videos/new
  # GET /case_speech_master_videos/new.xml
  def new
    @case_speech_master_video = CaseSpeechMasterVideo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @case_speech_master_video }
    end
  end

  # GET /case_speech_master_videos/1/edit
  def edit
    @case_speech_master_video = CaseSpeechMasterVideo.find(params[:id])
  end

  # POST /case_speech_master_videos
  # POST /case_speech_master_videos.xml
  def create
    @case_speech_master_video = CaseSpeechMasterVideo.new(params[:case_speech_master_video])

    respond_to do |format|
      if @case_speech_master_video.save
        flash[:notice] = 'CaseSpeechMasterVideo was successfully created.'
        format.html { redirect_to(@case_speech_master_video) }
        format.xml  { render :xml => @case_speech_master_video, :status => :created, :location => @case_speech_master_video }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @case_speech_master_video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /case_speech_master_videos/1
  # PUT /case_speech_master_videos/1.xml
  def update
    @case_speech_master_video = CaseSpeechMasterVideo.find(params[:id])

    respond_to do |format|
      if @case_speech_master_video.update_attributes(params[:case_speech_master_video])
        flash[:notice] = 'CaseSpeechMasterVideo was successfully updated.'
        format.html { redirect_to(@case_speech_master_video) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @case_speech_master_video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /case_speech_master_videos/1
  # DELETE /case_speech_master_videos/1.xml
  def destroy
    @case_speech_master_video = CaseSpeechMasterVideo.find(params[:id])
    @case_speech_master_video.destroy

    respond_to do |format|
      format.html { redirect_to(case_speech_master_videos_url) }
      format.xml  { head :ok }
    end
  end
end
