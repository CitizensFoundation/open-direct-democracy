module CaseSpeechVideosHelper
  def video_share_title(video)
    "#{video.title} #{t(:about_case)} #{video.case_discussion.case.info_1} - #{video.case_discussion.stage_sequence_number}. #{t(:stage_sequence_discussion)}"
  end

  def video_share_description(video)
    "#{video.title} #{t(:about_case)} #{video.case_discussion.case.info_1} (#{video.case_discussion.case.info_2}) / #{video.case_discussion.case.info_3} - #{video.case_discussion.stage_sequence_number}. #{t(:stage_sequence_discussion)}"
  end
end
