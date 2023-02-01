# It's a subclass of Devise's RegistrationsController, which is a subclass of Devise's
# ApplicationController
class RegistrationsController < Devise::RegistrationsController
    respond_to :json
    before_action :autorized_user?, except: %i[create new]

    def create
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        firebase_data = Firebase::AuthenticationManager.signup(resource.email, resource.password)

        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)

          # UserMailer.with(user: resource).welcome_email.deliver_now

          respond_with resource, { location: after_sign_up_path_for(resource), token: firebase_data['idToken'] }
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource), token: firebase_data['idToken']
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    private

    def respond_with(resource, opts = {})
      register_success(resource, opts) && return if resource.persisted?
  
      register_failed
    end
  
    def register_success(resource, opts)
      render json: { resource: resource, token: opts[:token], refresh_token: opts[:refreshToken]}
    end
  
    def register_failed
      render json: { message: "Something went wrong." }
    end
end