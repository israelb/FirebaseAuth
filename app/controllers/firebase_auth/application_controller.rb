module FirebaseAuth
  class ApplicationController < ActionController::Base
    include FirebaseAuth::Authentication

    before_action :ensure_firebase_config

    # This method determines the redirect path after a successful sign-in.
    # By default, it redirects to the root path.
    #
    # @param [Object] resource The authenticated resource (e.g., the user).
    # @return [String] The path to redirect to after sign-in.
    #
    # Example of overriding:
    #   def after_sign_in_path_for(resource)
    #     main_app.dashboard_path # Custom path
    #   end
    def after_sign_in_path_for(resource)
      main_app.root_path
    end

    private

    # Ensures Firebase configuration is loaded and valid.
    def ensure_firebase_config
      firebase_config
    rescue FirebaseHelper::ConfigurationError => e
      Rails.logger.error e.message
      render plain: "Configuration error: #{e.message}", status: :internal_server_error
    end
  end
end
