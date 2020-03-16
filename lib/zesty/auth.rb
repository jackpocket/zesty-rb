module Zesty
  class Auth

    AUTH_URL = "https://auth.api.zesty.io"

    def self.get_token(email, password)
      self.new.login(email, password).dig(:meta, :token)
    end

    def initialize(**options)
      @options = options
    end

    def login(email, password)
      Request.post_form(
        "#{AUTH_URL}/login",
        params: {
          email: email,
          password: password
        }
      )
    end

    def verify_token(token)
      Request.get("#{AUTH_URL}/verify", headers: { Authorization: "Bearer #{token}" })
    end

  end
end
