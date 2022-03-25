class WWWRedirectMiddleware < Marten::Middleware
  def call(request : Marten::HTTP::Request, get_response : Proc(Marten::HTTP::Response)) : Marten::HTTP::Response
    host = request.host.partition(":")[0]
    if host.starts_with?("www.")
      Marten::HTTP::Response::MovedPermanently.new("#{request.scheme}://#{host[4..]}#{request.path}")
    else
      get_response.call
    end
  end
end
