class Admin::SessionsController < ApplicationController
  layout 'login'

  def show
    if using_open_id?
      create
    else
      redirect_to :action => 'new'
    end
  end

  def new
  end

  def create
    # login bypass disabled until I find a better url parsing solution
    return successful_login(Author.with_open_id(params[:openid_url])) if allow_login_bypass? && params[:bypass_login]

    if params[:openid_url].blank? && !request.env[Rack::OpenID::RESPONSE]
      flash.now[:error] = "You must provide an OpenID URL"
      render :action => 'new'
    else
      authenticate_with_open_id(params[:openid_url]) do |result, identity_url|
        if result.successful?
          if author = Author.with_open_id(identity_url)
            return successful_login(author)
          else
            flash.now[:error] = "You are not authorized"
          end
        else
          flash.now[:error] = result.message
        end
        render :action => 'new'
      end
    end
  end


  def destroy
    session[:author_id] = nil
    redirect_to('/')
  end

protected

  def successful_login(author)
    session[:logged_in] = true
    session[:author_id] = author.id
    redirect_to(admin_root_path)
  end

  def allow_login_bypass?
    %w(development test).include?(Rails.env)
  end
  helper_method :allow_login_bypass?
end
