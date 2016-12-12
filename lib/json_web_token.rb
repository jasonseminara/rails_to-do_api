class JsonWebToken
  def self.encode(payload)
    JWT.encode payload, Rails.application.secrets.secret_key_base, 'RS512'
  end

  def self.decode(token)
    return JWT.decode token, rsa_public, true
  rescue
    nil
  end
end
