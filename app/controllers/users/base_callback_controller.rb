class Users::BaseCallbackController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_user
  before_action :validate_signature

  attr_accessor :user

  def new
    # Store user in session.
    self.user.signed_request_params.each do |key, value|
      session[key] = value
    end

    # Set up the callback URLs.
    session[:success_url] = params[:success] || partner.success_url
    session[:failure_url] = params[:failure] || partner.failure_url

    apply_helper
  end

  def callback
    apply_helper
  end

  private

  def apply_helper
    helper = self.user.imap_provider.helper_for(params[:action])
    self.send(helper)
  end

  def load_user(user_id = nil)
    # Load from params or for a specific auth method.
    self.user = User.find_by_id(user_id || params[:user_id] || session[:user_id])
    if self.user.nil?
      render :status => :not_found, :text => "User not found."
    end
  end

  def validate_signature(options = {})
    # Validate from params or for a specific auth method.
    is_valid =
      self.user.valid_signature?(options) ||
      self.user.valid_signature?(params) ||
      self.user.valid_signature?(session)

    if !is_valid
      render :status => :not_found, :text => "User not found."
    end
  end

  def connection
    self.user.connection
  end

  def partner
    self.user.connection.partner
  end

  def imap_provider
    self.user.connection.imap_provider
  end

  def redirect_to_success_url
    redirect_to session[:success_url]
  end

  def redirect_to_failure_url
    redirect_to session[:failure_url]
  end
end
