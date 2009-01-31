namespace :utils do
  desc "Backup"
  task(:backup => :environment) do
      filename = "beint_lydraedi_is_#{Time.new.strftime("%d%m%y_%H%M%S")}.sql"
      system("mysqldump -u robert --force --password=zaijei7E odd_dev_2 > /tmp/#{filename}")
      system("gzip /tmp/#{filename}")
      system("scp /tmp/#{filename}.gz robert@where.is:backups/#{filename}.gz")
  end
end
