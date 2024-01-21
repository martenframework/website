module Website
  class SitemapHandler < Marten::Handler
    def get
      render "sitemap.xml", {request: request, news: News.all}, content_type: "application/xml"
    end
  end
end
