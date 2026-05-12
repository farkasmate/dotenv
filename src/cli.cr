require "dotenv"

require "./config"
require "./help"
require "./log"
require "./pass"

module Dotenv
  VERSION = "0.2.1"

  private def parse_args : {String, Array(String)}
    args = ARGV.dup
    args.shift if !args.empty? && args.first == "--"

    cmd = if args.empty?
            "env"
          else
            args.shift
          end

    {cmd, args}
  end

  help if ARGV.empty?

  dirs = if Config::RECURSIVE
           Dir.current.split("/", remove_empty: true).accumulate("/") { |acc, dir| "#{acc}#{dir}/" }
         else
           [Dir.current]
         end
  dotenv_files = Dir.glob(dirs.map { |dir| Path[dir] / Config::FILE })

  begin
    dotenv_files.each do |dotenv|
      Log.info { "Loading #{dotenv}" }

      File.open(dotenv) { |file| Dotenv.load(file, override_keys: true) }
    end

    resolve_pass if Config::RESOLVE_PASS

    Process.exec(*parse_args)
  rescue ex
    Log.error { ex.message }
    ::exit 1
  end
end
