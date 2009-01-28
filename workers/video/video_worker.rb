require 'rubygems'
require 'daemons'
require 'yaml'

f = File.open( File.dirname(__FILE__) + '/config/worker.yml')
worker_config = YAML.load(f)

ENV['RAILS_ENV'] = worker_config['rails_env']

options = {
    :app_name   => "video_worker_"+ENV['RAILS_ENV'],
    :dir_mode   => :system,
    :backtrace  => true,
    :monitor    => true,
    :log_output => true,
    :script     => ENV['RAILS_ENV'] == "development" ? "/home/robert/work/ContentStoreDevelopment/lib/video_worker/video_worker_daemon.rb" : "/home/robert/work/ContentStoreProduction/lib/video_worker/video_worker_daemon.rb" 
  }

Daemons.run(File.join(File.dirname(__FILE__), 'video_worker_daemon.rb'), options)
