class AuthenticationController < ApplicationController

  def authenticate_user
    user = User.find_by(email: params[:email])
    if user.try(:authenticate, params[:password])
      render json: payload(user)
    else
      render json: {errors: ['Invalid Username/Password']}, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user&.token
    { auth_token: JsonWebToken.encode({
        u_id: user.token,
        iat: Time.new,
        nbf: Time.new,
        exp: Time.now.to_i + 4 * 3600,
        sub: 'userAuth'
      })
    }
  end
end
