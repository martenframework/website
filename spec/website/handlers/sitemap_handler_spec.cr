require "./spec_helper"

describe Website::SitemapHandler do
  describe "#get" do
    it "returns the expected sitemap" do
      response = Marten::Spec.client.get(Marten.routes.reverse("website:sitemap"))

      response.content_type.should eq "application/xml"

      [
        Marten.routes.reverse("website:code_of_conduct"),
        Marten.routes.reverse("website:news_detail", slug: "2023-07-10-marten-bugfix-release-0.3.1"),
      ].each do |url|
        response.content.includes?("<loc>http://127.0.0.1#{url}</loc>").should be_true
      end
    end
  end
end
