class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_search
  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def set_search
    if user_signed_in?
      @search_word = params[:q][:name_or_ingredients_name_cont] if params[:q]
      @q = current_user.feed.paginate(page: params[:page], per_page: 5).ransack(params[:q])
      @dishes = @q.result(distinct: true)
    end
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update,
                                        keys: [:username, :introduction, :profile_photo])
    end
end
