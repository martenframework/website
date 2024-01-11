module Website
  class NewsListHandler < Marten::Handlers::Template
    template_name "news_list.html"

    def context
      page_number = request.query_params["page"]?.try(&.to_i) || 1
      news = News.page(page_number)
      raise Marten::HTTP::Errors::NotFound.new if news.empty?

      has_previous_page = page_number > 1
      has_next_page = News.page(page_number + 1).any?

      {
        news_page:            news,
        previous_page_number: has_previous_page ? page_number - 1 : nil,
        next_page_number:     has_next_page ? page_number + 1 : nil,
      }
    end
  end
end
