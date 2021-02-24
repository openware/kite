module Kite
  class Vault < Base
    include Kite::Helpers

    class Otp
      def export
        keys = []
        exports = []
        legacy_key_paths = Dir.entries("totp/keys/*")
        legacy_export_paths = Dir.entries("totp/export/*")

        legacy_key_paths.each do |key|
          keys.push(key)
        end

        legacy_export_paths.each do |export|
          exports.push(key)
        end

        File.open("otp_keys.yml", "r+") do |file|
          file.write(keys.to_yaml)
        end

        File.open("otp_exports.yml", "r+") do |file|
          file.write(keys.to_yaml)
        end
      end

      def import
      end
    end

    class ApiKeys
      def export
        keys = []
        legacy_key_paths = Dir.entries("secret/barong/api_key/*")

        legacy_key_paths.each do |key|
          keys.push(key)
        end

        File.open("api_keys.yml", "r+") do |file|
          file.write(keys.to_yaml)
        end
      end

      def import
      end
    end

    def with_human_error
      raise ArgumentError, 'Block is required' unless block_given?
      yield
    rescue Vault::VaultError => e
      Rails.logger.error { e }
      if e.message.include?('connection refused')
        raise Error, '2FA server is under maintenance'
      end

      if e.message.include?('code already used')
        raise Error, 'This code was already used. Wait until the next time period'
      end

      raise e
    end
  end
end