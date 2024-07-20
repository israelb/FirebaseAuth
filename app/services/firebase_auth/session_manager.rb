module FirebaseAuth
  class SessionManager
    def initialize(session)
      @session = session
    end

    def create_session_for_user(user)
      token = encode_token(user_id: user.id)
      @session[:jwt] = token
    end

    def destroy_session
      @session[:jwt] = nil
    end

    def current_user
      token = @session[:jwt]
      decoded_token = decode_token(token)
      User.find(decoded_token["user_id"]) if decoded_token
    end

    private

    def encode_token(payload)
      JWT.encode(payload, Rails.application.credentials.secret_key_base)
    end

    def decode_token(token)
      JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
    rescue
      nil
    end
  end
end
