module Website
  class VersionContextProducer < Marten::Template::ContextProducer
    @version_data : Hash(String, String)?

    def produce(request : Marten::HTTP::Request? = nil)
      version_data
    end

    private def version_data : Hash(String, String)
      @version_data ||= begin
        response = HTTP::Client.get("https://api.github.com/repos/martenframework/marten/releases")

        parsed_body = JSON.parse(response.body)
        latest_release_tag = parsed_body.as_a.first.as_h["tag_name"].to_s
        latest_release_date = Time
          .parse_rfc3339(parsed_body.as_a.first.as_h["published_at"].to_s)
          .in(Time::Location.load("EST"))

        {
          "latest_version"       => latest_release_tag.scan(/^v(\d\.\d\.+\d+)/).try(&.first.captures.first).not_nil!,
          "latest_version_date"  => latest_release_date.to_s("%h %-d, %Y"),
          "latest_major_version" => latest_release_tag.scan(/^v(\d\.\d)\.+\d+$/).try(&.first.captures.first).not_nil!,
        }
      end
    end
  end
end
