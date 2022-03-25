require "./spec_helper"

describe WWWRedirectMiddleware do
  around_each do |t|
    original_allowed_hosts = Marten.settings.allowed_hosts

    Marten.settings.allowed_hosts = %w(example.com www.example.com)

    t.run

    Marten.settings.allowed_hosts = original_allowed_hosts
  end

  describe "#call" do
    it "calls the next middleware if the host does not start with www" do
      middleware = WWWRedirectMiddleware.new

      response = middleware.call(
        Marten::HTTP::Request.new(
          ::HTTP::Request.new(
            method: "GET",
            resource: "/foo/bar",
            headers: HTTP::Headers{"Host" => "example.com"}
          )
        ),
        ->{ Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200) }
      )

      response.should be_a Marten::HTTP::Response
      response.content.should eq "It works!"
    end

    it "returns a permanent redirect to the non-www URL if the host starts with www" do
      middleware = WWWRedirectMiddleware.new

      response = middleware.call(
        Marten::HTTP::Request.new(
          ::HTTP::Request.new(
            method: "GET",
            resource: "/foo/bar",
            headers: HTTP::Headers{"Host" => "www.example.com"}
          )
        ),
        ->{ Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200) }
      )

      response.should be_a Marten::HTTP::Response::MovedPermanently
      response.headers["Location"].should eq "http://example.com/foo/bar"
    end
  end
end
