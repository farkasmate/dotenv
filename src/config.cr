module Dotenv
  module Config
    private def self.truthy?(value : String?) : Bool
      return ["true", "1"].includes? value.to_s.downcase
    end

    FILE         = ENV["DOTENV_FILE"]? || ".env"
    PASS_DIR     = ENV["PASSWORD_STORE_DIR"]? || "#{ENV["HOME"]?}/.password-store"
    RECURSIVE    = truthy? ENV["DOTENV_RECURSIVE"]?
    RESOLVE_PASS = truthy? ENV["DOTENV_PASS"]?
    VERBOSE      = truthy? ENV["DOTENV_VERBOSE"]?
  end
end
