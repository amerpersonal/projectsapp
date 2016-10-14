class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  layout :layout_by_resource
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) << :attribute
  end

  def layout_by_resource
    if devise_controller? && !user_signed_in?
      "header"
    else
      "application"
    end
  end

  def after_sign_out_path_for(resource)
    user_signed_in? ? projects_path : new_user_session_path
  end

  def after_sign_in_path_for(resource)
    projects_path
  end
end
