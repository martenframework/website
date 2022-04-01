class RavenMiddleware < Marten::Middleware
  def call(request : Marten::HTTP::Request, get_response : Proc(Marten::HTTP::Response)) : Marten::HTTP::Response
    get_response.call
  rescue ex
    Raven.capture(ex) do |event|
      data = if CAPTURE_DATA_FOR_METHODS.includes?(request.method)
               prepare_data(request.data)
             else
               nil
             end

      event.culprit = "#{request.method} #{request.path}"
      event.logger ||= "marten"
      event.interface :http, {
        headers:      request.headers.to_h,
        cookies:      request.cookies.to_stdlib.to_h.join("; ") { |_, cookie| cookie.to_cookie_header },
        method:       request.method,
        url:          build_full_url(request),
        query_string: request.query_params.as_query,
        data:         data,
      }
    end

    raise ex
  end

  private CAPTURE_DATA_FOR_METHODS = %w(POST PUT PATCH)

  private def build_full_url(request)
    String.build do |url|
      url << request.scheme
      url << "://"
      url << request.host
      url << ":#{request.port}" if !["80", "443"].includes?(request.port)
      url << request.full_path
    end
  end

  private def prepare_data(data)
    prepared_data = {} of String => Array(String)

    data.each do |k, v|
      prepared_data[k] = v.map(&.to_s)
    end

    prepared_data
  end
end
