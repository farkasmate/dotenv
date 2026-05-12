require "./log"

module Dotenv
  class ResolvedEnv < Hash(String, String)
    ENV_VAR_REGEX = /[a-zA-Z_][a-zA-Z0-9_]*/

    def initialize
      super

      ENV.each { |key, value| self[key] = value }
    end

    def merge_env!(other : Hash(String, String))
      other.each do |key, value|
        unless value =~ /\$/
          self[key] = value

          next
        end

        value.scan(/\${?(?<var>#{ENV_VAR_REGEX}+)}?/).each do |match_data|
          var_name = match_data[0]
          replacement = self[match_data["var"]]? || raise "Variable not found '#{var_name}'"

          Log.debug { "Replacing '#{var_name}' in '#{key}=#{value}' with '#{replacement}'" }
          value = value.sub(var_name, replacement)
        end

        self[key] = value
      end
    end
  end
end
