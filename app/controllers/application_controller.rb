class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_paper_trail_whodunnit

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  protected
  def user_for_paper_trail
    admin_user_signed_in? ? current_admin_user.try(:id) : 'Unknown user'
  end
end
