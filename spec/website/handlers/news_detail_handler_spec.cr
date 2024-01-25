require "./spec_helper"

describe Website::NewsDetailHandler do
  describe "#render_to_response" do
    it "insert the news item into the context" do
      request = Marten::HTTP::Request.new(method: "GET", resource: "", headers: HTTP::Headers{"Host" => "127.0.0.1"})
      handler = Website::NewsDetailHandler.new(
        request,
        Marten::Routing::MatchParameters{"slug" => "2023-07-10-marten-bugfix-release-0.3.1"}
      )

      handler.render_to_response

      handler.context[:news].should eq Website::News.get("2023-07-10-marten-bugfix-release-0.3.1")
    end

    it "raises an error if the news slug does not correspond to an existing news" do
      request = Marten::HTTP::Request.new(method: "GET", resource: "", headers: HTTP::Headers{"Host" => "127.0.0.1"})
      handler = Website::NewsDetailHandler.new(
        request,
        Marten::Routing::MatchParameters{"slug" => "unknown"}
      )

      expect_raises(Marten::HTTP::Errors::NotFound) do
        handler.render_to_response
      end
    end
  end
end
