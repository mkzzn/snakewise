class ApplicationController < ActionController::Base
  before_filter :set_meta_tags

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected
  def set_meta_tags
    @meta_tags ||= {
      :title => "The Wisest of All Snakes | Front Page"
    }
  end
end
