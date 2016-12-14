class ApplicationController < ActionController::API
  before_action :check_header
  attr_reader :current_user

  protected
  def authenticate_request!
    head :unauthorized and return unless valid_token? && auth_token[0]['u_id']
    @current_user = User.find_by!(token: auth_token[0]['u_id'])

  rescue JWT::VerificationError, JWT::DecodeError, ActiveRecord::RecordNotFound => e
    head :unauthorized
  end


  private
  # Check to see if the client is using the right content_type (application/vnd.api+json)
  def check_header
    if ['POST','PUT','PATCH'].include? request.method
      if request.content_type != "application/vnd.api+json"
        head 406 and return
      end
    end
  end

  # Ruby 2.3.0 object-safe operator (&.)
  # http://mitrev.net/ruby/2015/11/13/the-operator-in-ruby/
  def validate_type
    if params&.data&.type == params[:controller]
      return true
    end
    head 409 and return
  end

  def validate_user
    token = request.headers["X-Api-Key"]
    head 403 and return unless token
    user = User.find_by token: token
    head 403 and return unless user
  end

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def valid_token?
    http_token && auth_token
  end


  def render_error(resource, status)
    render json: resource, status: status, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
  end
end
