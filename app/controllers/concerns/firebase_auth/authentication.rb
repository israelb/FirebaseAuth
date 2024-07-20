module FirebaseAuth
  module Authentication
    include FirebaseHelper
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :user_signed_in?
      helper_method :firebase_config

      before_action :set_firebase_config
    end

    private

    def authenticate_request
      unless session_manager.current_user
        redirect_to auth.login_path, alert: "You must be logged in to access this section"
      end
    end

    def session_manager
      @session_manager ||= FirebaseAuth::SessionManager.new(session)
    end

    def current_user
      session_manager.current_user
    end

    def user_signed_in?
      current_user.present?
    end

    def set_firebase_config
      @firebase_config ||= firebase_config
    end
  end
end
