class JsonWebToken
  def self.encode(payload)
    JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS512'
  end

  def self.decode(token)
    return JWT.decode token, Rails.application.secrets.secret_key_base, true
  rescue
    nil
  end
end
