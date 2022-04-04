require "./spec_helper"

describe RavenMiddleware do
  around_each do |t|
    original_allowed_hosts = Marten.settings.allowed_hosts

    Marten.settings.allowed_hosts = %w(example.com www.example.com)

    t.run

    Marten.settings.allowed_hosts = original_allowed_hosts
  end

  describe "#call" do
    it "returns the response as expected if no error occurs" do
      middleware = RavenMiddleware.new

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

    it "properly sets the event culprit when capturing an exception" do
      middleware = RavenMiddleware.new

      expect_raises(DivisionByZeroError) do
        middleware.call(
          Marten::HTTP::Request.new(
            ::HTTP::Request.new(
              method: "GET",
              resource: "/foo/bar",
              headers: HTTP::Headers{"Host" => "example.com"}
            )
          ),
          ->{
            1 // 0
            Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200)
          }
        )
      end

      event = Raven.instance.last_sent_event.not_nil!
      event.culprit.should eq "GET /foo/bar"
    end

    it "properly sets the event logger when capturing an exception" do
      middleware = RavenMiddleware.new

      expect_raises(DivisionByZeroError) do
        middleware.call(
          Marten::HTTP::Request.new(
            ::HTTP::Request.new(
              method: "GET",
              resource: "/foo/bar",
              headers: HTTP::Headers{"Host" => "example.com"}
            )
          ),
          ->{
            1 // 0
            Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200)
          }
        )
      end

      event = Raven.instance.last_sent_event.not_nil!
      event.logger.should eq "marten"
    end

    it "properly sets the HTTP interface when capturing an exception for a GET request" do
      middleware = RavenMiddleware.new

      expect_raises(DivisionByZeroError) do
        middleware.call(
          Marten::HTTP::Request.new(
            ::HTTP::Request.new(
              method: "GET",
              resource: "/foo/bar?foo=bar&xyz=test",
              headers: HTTP::Headers{"Host" => "example.com"}
            )
          ),
          ->{
            1 // 0
            Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200)
          }
        )
      end

      event = Raven.instance.last_sent_event.not_nil!
      http_interface = event.interface(:http).as(Raven::Interface::HTTP)

      http_interface.method.should eq "GET"
      http_interface.url.should eq "http://example.com/foo/bar?foo=bar&xyz=test"
      http_interface.headers.should eq({"Host" => ["example.com"]})
      http_interface.query_string.should eq "foo=bar&xyz=test"
      http_interface.data.should be_empty
    end

    it "properly sets the HTTP interface when capturing an exception for a POST request" do
      middleware = RavenMiddleware.new

      expect_raises(DivisionByZeroError) do
        middleware.call(
          Marten::HTTP::Request.new(
            ::HTTP::Request.new(
              method: "POST",
              resource: "/foo/bar?param=val",
              headers: HTTP::Headers{"Host" => "example.com", "Content-Type" => "application/x-www-form-urlencoded"},
              body: "foo=bar&test=xyz&foo=baz"
            )
          ),
          ->{
            1 // 0
            Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200)
          }
        )
      end

      event = Raven.instance.last_sent_event.not_nil!
      http_interface = event.interface(:http).as(Raven::Interface::HTTP)

      http_interface.method.should eq "POST"
      http_interface.url.should eq "http://example.com/foo/bar?param=val"
      http_interface.headers.should eq(
        {"Host" => ["example.com"], "Content-Type" => ["application/x-www-form-urlencoded"], "Content-Length" => ["24"]}
      )
      http_interface.query_string.should eq "param=val"
      http_interface.data.should eq({"foo" => ["bar", "baz"], "test" => ["xyz"]})
    end

    it "properly sets the HTTP interface when capturing an exception for a PUT request" do
      middleware = RavenMiddleware.new

      expect_raises(DivisionByZeroError) do
        middleware.call(
          Marten::HTTP::Request.new(
            ::HTTP::Request.new(
              method: "PUT",
              resource: "/foo/bar?param=val",
              headers: HTTP::Headers{"Host" => "example.com", "Content-Type" => "application/x-www-form-urlencoded"},
              body: "foo=bar&test=xyz&foo=baz"
            )
          ),
          ->{
            1 // 0
            Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200)
          }
        )
      end

      event = Raven.instance.last_sent_event.not_nil!
      http_interface = event.interface(:http).as(Raven::Interface::HTTP)

      http_interface.method.should eq "PUT"
      http_interface.url.should eq "http://example.com/foo/bar?param=val"
      http_interface.headers.should eq(
        {"Host" => ["example.com"], "Content-Type" => ["application/x-www-form-urlencoded"], "Content-Length" => ["24"]}
      )
      http_interface.query_string.should eq "param=val"
      http_interface.data.should eq({"foo" => ["bar", "baz"], "test" => ["xyz"]})
    end

    it "properly sets the HTTP interface when capturing an exception for a PATCH request" do
      middleware = RavenMiddleware.new

      expect_raises(DivisionByZeroError) do
        middleware.call(
          Marten::HTTP::Request.new(
            ::HTTP::Request.new(
              method: "PATCH",
              resource: "/foo/bar?param=val",
              headers: HTTP::Headers{"Host" => "example.com", "Content-Type" => "application/x-www-form-urlencoded"},
              body: "foo=bar&test=xyz&foo=baz"
            )
          ),
          ->{
            1 // 0
            Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200)
          }
        )
      end

      event = Raven.instance.last_sent_event.not_nil!
      http_interface = event.interface(:http).as(Raven::Interface::HTTP)

      http_interface.method.should eq "PATCH"
      http_interface.url.should eq "http://example.com/foo/bar?param=val"
      http_interface.headers.should eq(
        {"Host" => ["example.com"], "Content-Type" => ["application/x-www-form-urlencoded"], "Content-Length" => ["24"]}
      )
      http_interface.query_string.should eq "param=val"
      http_interface.data.should eq({"foo" => ["bar", "baz"], "test" => ["xyz"]})
    end

    it "properly sets the cookies in the HTTP interface" do
      raw_request = ::HTTP::Request.new(
        method: "GET",
        resource: "/foo/bar",
        headers: HTTP::Headers{"Host" => "example.com"}
      )
      raw_request.cookies["test"] = "value"

      request = Marten::HTTP::Request.new(raw_request)

      middleware = RavenMiddleware.new

      expect_raises(DivisionByZeroError) do
        middleware.call(
          request,
          ->{
            1 // 0
            Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200)
          }
        )
      end

      event = Raven.instance.last_sent_event.not_nil!
      http_interface = event.interface(:http).as(Raven::Interface::HTTP)

      http_interface.cookies.should eq "test=value"
    end

    it "does not capture HTTP not found exceptions" do
      middleware = RavenMiddleware.new

      expect_raises(Marten::HTTP::Errors::NotFound) do
        middleware.call(
          Marten::HTTP::Request.new(
            ::HTTP::Request.new(
              method: "PUT",
              resource: "/foo/bar?param=val",
              headers: HTTP::Headers{"Host" => "example.com", "Content-Type" => "application/x-www-form-urlencoded"},
              body: "foo=bar&test=xyz&foo=baz"
            )
          ),
          ->{
            raise Marten::HTTP::Errors::NotFound.new("This is bad")
            Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200)
          }
        )

        Raven.instance.last_sent_event.should be_nil
      end
    end

    it "does not capture route not found exceptions" do
      middleware = RavenMiddleware.new

      expect_raises(Marten::Routing::Errors::NoResolveMatch) do
        middleware.call(
          Marten::HTTP::Request.new(
            ::HTTP::Request.new(
              method: "PUT",
              resource: "/foo/bar?param=val",
              headers: HTTP::Headers{"Host" => "example.com", "Content-Type" => "application/x-www-form-urlencoded"},
              body: "foo=bar&test=xyz&foo=baz"
            )
          ),
          ->{
            raise Marten::Routing::Errors::NoResolveMatch.new("This is bad")
            Marten::HTTP::Response.new("It works!", content_type: "text/plain", status: 200)
          }
        )

        Raven.instance.last_sent_event.should be_nil
      end
    end
  end
end
