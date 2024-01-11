require "./spec_helper"

describe Website::NewsListHandler do
  describe "#context" do
    it "returns the news page and page numbers when no page parameter is set" do
      request = Marten::HTTP::Request.new(method: "GET", resource: "")
      handler = Website::NewsListHandler.new(request)

      context = handler.context
      context[:news_page].should be_a Array(Website::News)
      context[:previous_page_number].should be_nil
      context[:next_page_number].should eq 2
    end

    it "returns the expected page and page numbers when a page parameter is set" do
      request = Marten::HTTP::Request.new(method: "GET", resource: "?page=2")
      handler = Website::NewsListHandler.new(request)

      context = handler.context
      context[:news_page].should be_a Array(Website::News)
      context[:previous_page_number].should eq 1
      (context[:next_page_number].nil? || context[:next_page_number].not_nil! > 2).should be_true
    end

    it "raises an error when the page parameter does not map to any page" do
      request = Marten::HTTP::Request.new(method: "GET", resource: "?page=100")
      handler = Website::NewsListHandler.new(request)

      expect_raises(Marten::HTTP::Errors::NotFound) do
        handler.context
      end
    end
  end
end
