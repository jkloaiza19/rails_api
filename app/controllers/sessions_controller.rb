class SessionsController < Devise::SessionsController
include UserConcern
    respond_to :json
    before_action :autorized_user?, except: %i[create new]

    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)

      firebase_data = Firebase::AuthenticationManager.signin(sign_in_params[:email], sign_in_params[:password])

      yield resource if block_given?

      user_data = user_app_data(resource)
      respond_with user_data, { location: after_sign_in_path_for(resource), token: firebase_data['idToken'], refresh_token: firebase_data['refreshToken'] }
    end

    private
    def respond_with(resource, opts = {})
      render json: { resource: resource, location: opts[:location], token: opts[:token], refresh_token: opts[:refreshToken] }
    end
    
    def respond_to_on_destroy
      head :ok
    end

end