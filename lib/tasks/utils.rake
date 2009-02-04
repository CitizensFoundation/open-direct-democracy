namespace :utils do
  desc "Backup"
  task(:backup => :environment) do
      filename = "beint.lydraedi.is_#{Time.new.strftime("%d%m%y_%H%M%S")}.sql"
      system("mysqldump -u robert --force --password=zaijei7E odd_master > /tmp/#{filename}")
      system("gzip /tmp/#{filename}")
      system("scp /tmp/#{filename}.gz robert@where.is:backups/#{filename}.gz")
      system("rm /tmp/#{filename}.gz")
  end

  desc "Delete Fully Processed Masters"
  task(:delete_fullly_processed_masters => :environment) do
      masters = CaseSpeechMasterVideo.find(:all, :conditions=>["updated_at < ?",Time.now-1.days])
      masters.each do |master_video|
        if master_video.case_speech_videos.all_done?
          master_video_flv_filename = "#{RAILS_ROOT}/private/"+ENV['RAILS_ENV']+"/case_speech_master_videos/#{master_video.id}/master.flv"
          rm_string = "rm #{master_video_flv_filename}"
          puts rm_string
          system(rm_string)
        end
      end
  end
end
