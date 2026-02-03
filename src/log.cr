require "colorize"
require "log"

require "./config"

module Dotenv
  ::Log.setup_from_env(
    default_level: Config::VERBOSE ? ::Log::Severity::Info : ::Log::Severity::Warn,
    backend: ::Log::IOBackend.new(
      io: STDERR,
      dispatcher: ::Log::DispatchMode::Sync,
      formatter: ::Log::Formatter.new do |entry, io|
        log_color = case entry.severity
                    when ::Log::Severity::Info
                      :yellow
                    else
                      :red
                    end

        io << "[#{entry.source}] ".colorize(log_color) unless entry.source.empty?
        io << entry.message.colorize(log_color)
      end
    ),
  )

  Log = ::Log.for(self)
end
