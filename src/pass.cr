require "gpgme"
require "yaml"

require "./config"
require "./env"
require "./log"

module Dotenv
  PASS_CACHE = Hash(Path, Array(String)).new

  private def decrypt(path) : Array(String)
    Log.debug { "Decrypting #{path}..." }

    if PASS_CACHE.has_key? path
      Log.debug { "Using cached value for #{path}" }
    else
      raise "Secret file not found: #{path}" unless File.exists? path

      cleartext = GPGME.decrypt(File.read(path))

      raise "First line of secret file must be password and the second line username: #{path}" if cleartext.size < 2

      password, username, *_ = cleartext.lines

      PASS_CACHE[path] = cleartext.gsub(/^.*---\n/m, "password: #{password}\nusername: #{username}\n---\n").lines
    end

    return PASS_CACHE[path]
  end

  private def resolve_pass(env : ResolvedEnv)
    Log.info { "Resolving pass secrets..." } if env.any? { |_, v| v.starts_with? "pass://" }

    env.each do |key, value|
      next unless value.starts_with? "pass://"

      path = Path[value.lchop("pass://")]
      secret_name = path.dirname
      yaml_dig = path.basename

      secret_file_path = Path[Config::PASS_DIR] / "#{secret_name}.gpg"

      cleartext = decrypt(secret_file_path)

      yamls = YAML.parse_all(cleartext.join("\n"))
      yamls.each do |yaml|
        digs = yaml_dig.lstrip(".").split(".")
        begin
          digs.each { |dig| yaml = yaml[dig] }
        rescue KeyError
          Log.debug { "Key not found: #{yaml_dig} in #{secret_name}" }
        end

        if yaml.as_s?
          env[key] = yaml.as_s
          break
        end
      end

      if env[key].starts_with? "pass://"
        raise "Could not resolve key #{yaml_dig} in #{secret_name} as String"
      end
    end
  end
end
