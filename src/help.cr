module Dotenv
  private macro build_date
    {{ system("date '+%Y-%m-%d'").strip.stringify }}
  end

  private macro build_hash
    {{ system("git rev-parse --short HEAD").strip.stringify }}
  end

  private def help
    STDERR.puts <<-HELP
      Usage: dotenv [--] [COMMAND] [ARGUMENTS...]
        DOTENV_FILE          Set to change .env file name
        DOTENV_PASS          Set to resolve secrets from pass
        DOTENV_RECURSIVE     Set to load .env files recursively
        DOTENV_VERBOSE       Set to print which .env files have been loaded
        (PASSWORD_STORE_DIR) Set to change pass store location

      Dotenv #{VERSION} [#{build_hash}] (#{build_date})
      HELP
    ::exit 2
  end
end
