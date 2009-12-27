# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  helper :all # include all helpers, all the time
#  helper :current_author

  after_filter :set_content_type

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
#  protect_from_forgery :secret => 'a6a9e417376364b61645d469f04ac8cf'

  def current_author
#    @current_author ||= session[:author_id] && Author.find(session[:author_id])
    @current_author ||= Author.find(session[:author_id]) if session[:author_id]
  end

  protected

  def set_content_type
    headers['Content-Type'] ||= 'application/xhtml+xml; charset=utf-8'
  end

  def config
    @@config = Enki::Config.default
  end
  helper_method :config

end

