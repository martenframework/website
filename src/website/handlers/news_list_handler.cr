module Website
  class NewsListHandler < Marten::Handlers::Template
    template_name "news_list.html"

    before_render :prepare_context

    private def prepare_context
      page_number = request.query_params["page"]?.try(&.to_i) || 1
      news = News.page(page_number)
      raise Marten::HTTP::Errors::NotFound.new if news.empty?

      has_previous_page = page_number > 1
      has_next_page = News.page(page_number + 1).present?

      context[:news_page] = news
      context[:previous_page_number] = has_previous_page ? page_number - 1 : nil
      context[:next_page_number] = has_next_page ? page_number + 1 : nil
    end
  end
end
