require "./spec_helper"

describe Website::NewsDetailHandler do
  describe "#context" do
    it "returns a context object containing the news item" do
      request = Marten::HTTP::Request.new(method: "GET", resource: "")
      handler = Website::NewsDetailHandler.new(
        request,
        Hash(String, Marten::Routing::Parameter::Types){"slug" => "2023-07-10-marten-bugfix-release-0.3.1"}
      )

      context = handler.context
      context[:news].should eq Website::News.get("2023-07-10-marten-bugfix-release-0.3.1")
    end

    it "raises an error if the news slug does not correspond to an existing news" do
      request = Marten::HTTP::Request.new(method: "GET", resource: "")
      handler = Website::NewsDetailHandler.new(
        request,
        Hash(String, Marten::Routing::Parameter::Types){"slug" => "unknown"}
      )

      expect_raises(Marten::HTTP::Errors::NotFound) do
        handler.context
      end
    end
  end
end
