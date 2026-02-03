module Dotenv
  private def help
    STDERR.puts <<-HELP
      Usage: dotenv [--] [COMMAND] [ARGUMENTS...]
        DOTENV_FILE          Set to change .env file name
        DOTENV_PASS          Set to resolve secrets from pass
        DOTENV_RECURSIVE     Set to load .env files recursively
        DOTENV_VERBOSE       Set to print which .env files have been loaded
        (PASSWORD_STORE_DIR) Set to change pass store location
      HELP
    ::exit 2
  end
end
