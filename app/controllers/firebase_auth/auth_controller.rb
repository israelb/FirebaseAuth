module FirebaseAuth
  class AuthController < ApplicationController
    before_action :redirect_if_authenticated, only: [:new_login, :new_signup]

    def new_signup
      # Renderizar el formulario de registro
      render :new_signup
    end

    def create_signup
      email = params[:email]
      password = params[:password]

      begin
        FirebaseApp.auth.create_user(email: email, password: password)
        authenticate_user_with_email_and_password(email, password)
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end

    def new_login
      # Renderizar el formulario de inicio de sesión
      render :new_login
    end

    def create_login
      if params[:id_token]
        # Autenticación con Google
        id_token = params[:id_token]
        claims = FirebaseAuth::FirebaseAuthService.verify_id_token(id_token)

        handle_authentication(claims)
      else
        begin
          authenticate_user_with_email_and_password(params[:email], params[:password])
        rescue => e
          flash[:alert] = e.message
          respond_to do |format|
            format.html { render :new_login }
            format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "layouts/flash") }
          end
        end
      end
    end

    def destroy
      session_manager.destroy_session
      redirect_to login_path, notice: 'Successfully logged out'
    end

    private

    def authenticate_user_with_email_and_password(email, password)
      token_info = FirebaseAuth::FirebaseAuthService.sign_in_with_email_password(email, password)

      if token_info["error"]
        raise StandardError.new(token_info["error"]["message"])
      end

      id_token = token_info.fetch("idToken")
      claims = FirebaseAuth::FirebaseAuthService.verify_id_token(id_token)
      handle_authentication(claims)
    end

    def handle_authentication(claims)
      if claims
        user = User.find_or_create_by(firebase_uid: claims['user_id']) do |u|
          u.email = claims['email']
        end

        session_manager.create_session_for_user(user)

        # reset flash message to avoid showing it on the next page
        flash[:notice] = ''

        # respond in json format for AJAX requests
        respond_to do |format|
          format.html { redirect_to main_app.dashboard_path, notice: 'Successfully logged in' }
          format.json { render json: { redirect_url: main_app.dashboard_path }, status: :ok }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "layouts/flash") }
        end
      else
        respond_to do |format|
          format.html do
            flash[:alert] = 'Failed to verify ID token'
            render :new_login
          end
          format.json { render json: { error: 'Failed to verify ID token' }, status: :unprocessable_entity }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "layouts/flash") }
        end
      end
    end

    def session_manager
      @session_manager ||= FirebaseAuth::SessionManager.new(session)
    end

    def redirect_if_authenticated
      redirect_to main_app.dashboard_path if user_signed_in?
    end
  end
end
