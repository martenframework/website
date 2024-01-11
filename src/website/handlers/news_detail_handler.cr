module Website
  class NewsDetailHandler < Marten::Handlers::Template
    template_name "news_detail.html"

    def context
      news = News.get(slug: params["slug"].to_s)
      raise Marten::HTTP::Errors::NotFound.new if news.nil?

      {news: news, request: request}
    end
  end
end
