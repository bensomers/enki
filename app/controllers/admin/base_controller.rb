class Admin::BaseController < ApplicationController
  layout 'admin'

  before_filter :require_login

  def current_author
#    @current_author ||= session[:author_id] && Author.find(session[:author_id])
    @current_author ||= Author.find(session[:author_id]) if session[:author_id]
  end

  protected

  def require_login
    return redirect_to(admin_session_path) unless session[:logged_in]
  end

  def set_content_type
    headers['Content-Type'] ||= 'text/html; charset=utf-8'
  end

end

