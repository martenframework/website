require "./spec_helper"

describe Website::CodeOfConductHandler do
  describe "#dispatch" do
    it "contains the expected content" do
      request = Marten::HTTP::Request.new(::HTTP::Request.new(method: "GET", resource: "", headers: HTTP::Headers.new))
      handler = Website::CodeOfConductHandler.new(request)

      response = handler.dispatch

      response.status.should eq 200

      expected_content = Cmark
        .commonmark_to_html({{ read_file("lib/marten/CODE_OF_CONDUCT.md") }})
        .gsub(/<h1>.*<\/h1>/, "")

      response.content.includes?(expected_content).should be_true
    end
  end
end
