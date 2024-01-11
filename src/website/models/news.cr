module Website
  class News
    include Marten::Template::Object::Auto

    @@manifest : Hash(String, News)?

    @html : String?
    @publication_date : Time?

    getter author_github
    getter author_name
    getter description
    getter slug
    getter title

    def self.get(slug : String) : News?
      manifest[slug]?
    end

    def self.page(page : Int) : Array(News)
      manifest.values[(page - 1) * PAGE_SIZE, PAGE_SIZE]? || Array(News).new
    end

    private PAGE_SIZE = 10

    private def self.manifest
      @@manifest ||= begin
        parsed_manifest = File.open("#{__DIR__}/../../../news/manifest.yml") do |file|
          YAML.parse(file)
        end

        m = Hash(String, News).new

        parsed_manifest["news"].as_a.each do |news_metadata|
          slug = File.basename(news_metadata["file"].as_s, ".md")
          content = File.read("#{__DIR__}/../../../news/#{news_metadata["file"].as_s}")

          m[slug] = News.new(
            slug: slug,
            title: news_metadata["title"].as_s,
            description: news_metadata["description"].as_s,
            author_name: news_metadata["author"]["name"].as_s,
            author_github: news_metadata["author"]["github"].as_s,
            content: content,
          )
        end

        m
      end
    end

    def initialize(
      @slug : String,
      @title : String,
      @description : String,
      @author_name : String,
      @author_github : String,
      @content : String
    )
    end

    def formatted_publication_date
      publication_date.to_s("%h %-d, %Y")
    end

    def html
      @html ||= begin
        source = Cmark.commonmark_to_html(@content)
        source.gsub(/<h1>.*<\/h1>/, "")
      end
    end

    def publication_date
      @publication_date ||= Time.parse_local(slug.split("-")[...3].join("-"), "%Y-%m-%d")
    end
  end
end
