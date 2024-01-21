require "./spec_helper"

describe Website::News do
  describe "::all" do
    it "returns all the news" do
      news = Website::News.all

      (news.size > 1).should be_true
      news.all?(Website::News).should be_true
    end
  end

  describe "::get" do
    it "returns the news corresponding to the given slug" do
      news = Website::News.get("2023-07-10-marten-bugfix-release-0.3.1")

      news.should_not be_nil
      news.try(&.slug).should eq "2023-07-10-marten-bugfix-release-0.3.1"
    end

    it "returns nil if no news exists for the passed slug" do
      Website::News.get("unknown").should be_nil
    end
  end

  describe "::page" do
    it "returns the news page corresponding to the given page number" do
      page_1 = Website::News.page(1)
      page_1.size.should eq 10
      page_1.all?(Website::News).should be_true

      page_2 = Website::News.page(2)
      page_2.all? { |news| !page_1.includes?(news) }.should be_true
    end

    it "returns an empty array if no news exists for the passed page number" do
      Website::News.page(10000).should be_empty
    end
  end

  describe "#author_github" do
    it "returns the author's github URL" do
      news = Website::News.get("2023-07-10-marten-bugfix-release-0.3.1").not_nil!
      news.author_github.should eq "https://github.com/ellmetha"
    end
  end

  describe "#author_name" do
    it "returns the author's name" do
      news = Website::News.get("2023-07-10-marten-bugfix-release-0.3.1").not_nil!
      news.author_name.should eq "Morgan Aubert"
    end
  end

  describe "#description" do
    it "returns the news description" do
      news = Website::News.get("2023-07-10-marten-bugfix-release-0.3.1").not_nil!
      news.description.should eq(
        "Marten 0.3.1 introduces bug fixes, enhancing the stability and performance of the framework for a more " \
        "reliable development experience."
      )
    end
  end

  describe "#formatted_publication_date" do
    it "returns the news publication date in a human readable format" do
      news = Website::News.get("2023-07-10-marten-bugfix-release-0.3.1").not_nil!
      news.formatted_publication_date.should eq "Jul 10, 2023"
    end
  end

  describe "#html" do
    it "returns the news HTML content" do
      news = Website::News.get("2023-07-10-marten-bugfix-release-0.3.1").not_nil!
      news.html.includes?("0.3.1 bugfix release").should be_true
    end
  end

  describe "#publication_date" do
    it "returns the news publication date" do
      news = Website::News.get("2023-07-10-marten-bugfix-release-0.3.1").not_nil!
      news.publication_date.should eq Time.local(2023, 7, 10)
    end
  end

  describe "#slug" do
    it "returns the news slug" do
      news = Website::News.get("2023-07-10-marten-bugfix-release-0.3.1").not_nil!
      news.slug.should eq "2023-07-10-marten-bugfix-release-0.3.1"
    end
  end

  describe "#title" do
    it "returns the news title" do
      news = Website::News.get("2023-07-10-marten-bugfix-release-0.3.1").not_nil!
      news.title.should eq "Marten bugfix release: 0.3.1"
    end
  end
end
