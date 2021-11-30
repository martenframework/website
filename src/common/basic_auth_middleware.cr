class BasicAuthMiddleware < Marten::Middleware
  def call(request : Marten::HTTP::Request, get_response : Proc(Marten::HTTP::Response)) : Marten::HTTP::Response
    if authorized?(request)
      return get_response.call
    end

    response = Marten::HTTP::Response.new(content: "Invalid basic auth credentials.", status: 401)
    response.headers["WWW-Authenticate"] = "Basic realm=\"Login Required\""

    response
  end

  private AUTH_HEADER       = "Authorization"
  private BASIC_AUTH_PREFIX = "Basic"

  private def authorized?(request)
    return false if !request.headers[AUTH_HEADER]?

    auth_header = request.headers[AUTH_HEADER]
    return false if !(auth_header.size > 0 && auth_header.starts_with?(BASIC_AUTH_PREFIX))

    given_username, given_password = Base64.decode_string(auth_header[BASIC_AUTH_PREFIX.size + 1..-1]).split(":")

    expected_username = Marten.settings.basic_auth.username
    return false if !Crypto::Subtle.constant_time_compare(given_username, expected_username)

    expected_password = Marten.settings.basic_auth.password
    Crypto::Subtle.constant_time_compare(given_password, expected_password)
  end
end
