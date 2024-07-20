require 'jwt'
require 'json'

module FirebaseAuth
  class FirebaseAuthService
    GOOGLE_CERTS_URL = 'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'.freeze
    PRIVATE_KEY_ID = Rails.application.credentials.dig(:firebase, :api_key)

    def self.credentials
      @credentials ||= JSON.parse(File.read(Rails.root.join('config/firebase_credentials.json')))
    end

    def self.service_account_email
      credentials['client_email']
    end

    def self.project_id
      credentials['project_id']
    end

    def self.private_key
      OpenSSL::PKey::RSA.new(credentials['private_key'])
    end

    def self.sign_in_with_email_password(email, password)
      uri = URI.parse("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=#{Rails.env.test? ? 'fake_api_key' : PRIVATE_KEY_ID}")
      request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      request.body = {
        email: email,
        password: password,
        returnSecureToken: true
      }.to_json

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      JSON.parse(response.body)
    end

    def self.verify_id_token(id_token)
      FirebaseApp.auth.verify_id_token(id_token)
    rescue => e
      Rails.logger.error "Error verifying ID token: #{e.message}"
      nil
    end
  end
end
