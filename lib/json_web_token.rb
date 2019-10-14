# lib/json_web_token.rb
class JsonWebToken
  class << self
    def encode(payload)
      JWT.encode(payload, Rails.application.secret_key_base)
    end

    def decode(token)
      HashWithIndifferentAccess.new(
          JWT.decode(
              token,
              Rails.application.secret_key_base
          )[0]
      )
    rescue
      nil
    end
  end
end
