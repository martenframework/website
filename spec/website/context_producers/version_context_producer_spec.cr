require "./spec_helper"

describe Website::VersionContextProducer do
  before_each do
    WebMock.reset
  end

  describe "#produce" do
    it "returns the expected context hash when the latest tag is a patch release tag" do
      WebMock
        .stub(:get, "https://api.github.com/repos/martenframework/marten/releases")
        .to_return(
          body: <<-JSON
            [
              {
                "tag_name": "v0.2.3",
                "published_at": "2022-10-24T23:44:21Z"
              },
              {
                "tag_name": "v0.2.2",
                "published_at": "2022-10-22T23:44:21Z"
              }
            ]
          JSON
        )

      context_producer = Website::VersionContextProducer.new
      context_producer.produce.should eq(
        {
          "latest_version"       => "0.2.3",
          "latest_version_date"  => Time.parse_rfc3339("2022-10-24T23:44:21Z").to_s("%h %-d, %Y"),
          "latest_major_version" => "0.2",
        }
      )
    end

    it "returns the expected context hash when the latest tag is a major release tag" do
      WebMock
        .stub(:get, "https://api.github.com/repos/martenframework/marten/releases")
        .to_return(
          body: <<-JSON
            [
              {
                "tag_name": "v0.2.0",
                "published_at": "2022-10-24T23:44:21Z"
              },
              {
                "tag_name": "v0.1.5",
                "published_at": "2022-10-22T23:44:21Z"
              }
            ]
          JSON
        )

      context_producer = Website::VersionContextProducer.new
      context_producer.produce.should eq(
        {
          "latest_version"       => "0.2.0",
          "latest_version_date"  => Time.parse_rfc3339("2022-10-24T23:44:21Z").to_s("%h %-d, %Y"),
          "latest_major_version" => "0.2",
        }
      )
    end
  end
end
