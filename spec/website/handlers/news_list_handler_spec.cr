require "./spec_helper"

describe Website::NewsListHandler do
  describe "#render_to_response" do
    it "returns the news page and page numbers when no page parameter is set" do
      request = Marten::HTTP::Request.new(method: "GET", resource: "")
      handler = Website::NewsListHandler.new(request)

      handler.render_to_response

      handler.context[:news_page].map(&.raw).all?(Website::News).should be_true
      handler.context[:previous_page_number].raw.should be_nil
      handler.context[:next_page_number].should eq 2
    end

    it "returns the expected page and page numbers when a page parameter is set" do
      request = Marten::HTTP::Request.new(method: "GET", resource: "?page=2")
      handler = Website::NewsListHandler.new(request)

      handler.render_to_response

      handler.context[:news_page].map(&.raw).all?(Website::News).should be_true
      handler.context[:previous_page_number].should eq 1
      (
        handler.context[:next_page_number].raw.nil? || (handler.context[:next_page_number].raw.as(Int) > 2)
      ).should be_true
    end

    it "raises an error when the page parameter does not map to any page" do
      request = Marten::HTTP::Request.new(method: "GET", resource: "?page=100")
      handler = Website::NewsListHandler.new(request)

      expect_raises(Marten::HTTP::Errors::NotFound) do
        handler.render_to_response
      end
    end
  end
end
