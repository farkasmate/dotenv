require "dotenv"

require "./config"
require "./env"
require "./help"
require "./log"
require "./pass"

module Dotenv
  VERSION = "0.3.0"

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
    env = ResolvedEnv.new

    dotenv_files.each do |dotenv|
      Log.info { "Loading #{dotenv}" }

      File.open(dotenv) { |file| env.merge_env!(Dotenv.parse(file)) }
    end

    resolve_pass(env) if Config::RESOLVE_PASS

    Process.exec(*parse_args, env: env)
  rescue ex
    Log.error { ex.message }

    ::exit 1
  end
end
