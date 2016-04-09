class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  PER_PAGE = 1

  def home

  end

  def dig
    words = params[:words][:sentence]
    @pages = Digger.dig(words)
    respond_to do |format|
      format.js { render 'dig' }
    end
  end

end
