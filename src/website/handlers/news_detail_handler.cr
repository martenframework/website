module Website
  class NewsDetailHandler < Marten::Handlers::Template
    template_name "news_detail.html"

    before_render :prepare_context

    private def prepare_context
      news = News.get(slug: params["slug"].to_s)
      raise Marten::HTTP::Errors::NotFound.new if news.nil?

      context[:news] = news
    end
  end
end
