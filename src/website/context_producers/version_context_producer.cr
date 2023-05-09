module Website
  class VersionContextProducer < Marten::Template::ContextProducer
    @version_data : Hash(String, String)?

    def produce(request : Marten::HTTP::Request? = nil)
      version_data
    end

    private def version_data : Hash(String, String)
      @version_data ||= begin
        response = HTTP::Client.get("https://api.github.com/repos/martenframework/marten/tags")
        latest_tag = JSON.parse(response.body).as_a.first.as_h["name"].to_s

        {
          "latest_version"       => latest_tag.scan(/^v(\d\.\d\.+\d+)/).try(&.first.captures.first).not_nil!,
          "latest_major_version" => latest_tag.scan(/^v(\d\.\d)\.+\d+$/).try(&.first.captures.first).not_nil!,
        }
      end
    end
  end
end
