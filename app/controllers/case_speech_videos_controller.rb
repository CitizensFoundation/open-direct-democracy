class CaseSpeechVideosController < ApplicationController
  layout "citizen"

  skip_before_filter :check_authentication, :only =>  [  :show, :search ]
  skip_before_filter :check_authorization, :only =>  [ :show, :search ]  

  
  def search
    @case_speech_videos = CaseSpeechVideo.find(:all, :conditions=>['published = 1 AND LOWER(title) LIKE ?','%'+params[:search_query].downcase+'%'])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @case_speech_videos }
    end
  end
  
  # GET /case_speech_videos
  # GET /case_speech_videos.xml
  def index
    @case_speech_videos = CaseSpeechVideo.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @case_speech_videos }
    end
  end

  # GET /case_speech_videos/1
  # GET /case_speech_videos/1.xml
  def show
    if params[:only_update_details]
      a = params[:clip_info][0..params[:clip_info].index("speech.flv")-2]
      id_s = a[a.rindex("/")+1..a.length]
      @case_speech_video = CaseSpeechVideo.find(id_s.to_i)
      render :update do |page|  
        page.replace_html "case_speech_detail", :partial => "video_detail", :locals => {:case_speech_video=> @case_speech_video }  
        page.visual_effect :highlight, "case_speech_detail",  {:restorecolor=>"#ffffff", :startcolor=>"#cccccc", :endcolor=>"#ffffff"}  
      end
    else
      @case_speech_video = CaseSpeechVideo.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @case_speech_video }
      end
    end
  end

  # GET /case_speech_videos/new
  # GET /case_speech_videos/new.xml
  def new
    @case_speech_video = CaseSpeechVideo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @case_speech_video }
    end
  end

  # GET /case_speech_videos/1/edit
  def edit
    @case_speech_video = CaseSpeechVideo.find(params[:id])
  end

  # POST /case_speech_videos
  # POST /case_speech_videos.xml
  def create
    @case_speech_video = CaseSpeechVideo.new(params[:case_speech_video])

    respond_to do |format|
      if @case_speech_video.save
        flash[:notice] = 'CaseSpeechVideo was successfully created.'
        format.html { redirect_to(@case_speech_video) }
        format.xml  { render :xml => @case_speech_video, :status => :created, :location => @case_speech_video }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @case_speech_video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /case_speech_videos/1
  # PUT /case_speech_videos/1.xml
  def update
    @case_speech_video = CaseSpeechVideo.find(params[:id])

    respond_to do |format|
      if @case_speech_video.update_attributes(params[:case_speech_video])
        flash[:notice] = 'CaseSpeechVideo was successfully updated.'
        format.html { redirect_to(@case_speech_video) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @case_speech_video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /case_speech_videos/1
  # DELETE /case_speech_videos/1.xml
  def destroy
    @case_speech_video = CaseSpeechVideo.find(params[:id])
    @case_speech_video.destroy

    respond_to do |format|
      format.html { redirect_to(case_speech_videos_url) }
      format.xml  { head :ok }
    end
  end
end
