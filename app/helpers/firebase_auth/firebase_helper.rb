module FirebaseAuth
  module FirebaseHelper
    class ConfigurationError < StandardError; end

    def firebase_config
      @config ||= {
        apiKey: fetch_credential(:api_key),
        authDomain: fetch_credential(:auth_domain),
        projectId: fetch_credential(:project_id),
        storageBucket: fetch_credential(:storage_bucket),
        messagingSenderId: fetch_credential(:messaging_sender_id),
        appId: fetch_credential(:app_id)
      }
    end

    private

    def fetch_credential(key)
      value = Rails.application.credentials.dig(:firebase, key)
      raise ConfigurationError, "Missing Firebase credential: #{key}" if value.nil?
      value
    end
  end
end
