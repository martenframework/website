require "./spec_helper"

describe Website::ChatHandler do
  describe "#dispatch" do
    it "produces the expected redirect" do
      request = Marten::HTTP::Request.new(::HTTP::Request.new(method: "GET", resource: "", headers: HTTP::Headers.new))
      handler = Website::ChatHandler.new(request)

      response = handler.dispatch

      response.status.should eq 302
      response.headers["Location"].should eq Marten.settings.website.discord_invitation_link
    end
  end
end
