class MediaFormatException < StandardError
end

class Shell
  def initialize(logger)
    @logger = logger
  end

  def log_time
    t = Time.now
    "%02d:%02d:%02d.%06d" % [t.hour, t.min, t.sec, t.usec]
  end

  def execute(command)
    @logger.info("Execute: #{command}")
    IO.popen(command) do |pipe|
      pipe.each("\r") do |line|
        @logger.debug(line)
        $defout.flush
      end
    end
    raise MediaFormatException if $?.exitstatus != 0
  end
end
