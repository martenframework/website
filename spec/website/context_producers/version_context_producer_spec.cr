require "./spec_helper"

describe Website::VersionContextProducer do
  describe "#produce" do
    it "returns the expected context hash when the latest tag is a patch release tag" do
      WebMock
        .stub(:get, "https://api.github.com/repos/martenframework/marten/tags")
        .to_return(
          body: <<-JSON
            [
              {
                "name": "v0.2.3",
                "zipball_url": "https://example.com",
                "tarball_url": "https://example.com",
                "commit": {
                  "sha": "12345",
                  "url": "https://example.com"
                },
                "node_id": "12345"
              },
              {
                "name": "v0.2.2",
                "zipball_url": "https://example.com",
                "tarball_url": "https://example.com",
                "commit": {
                  "sha": "12345",
                  "url": "https://example.com"
                },
                "node_id": "12345"
              }
            ]
          JSON
        )

      context_producer = Website::VersionContextProducer.new
      context_producer.produce.should eq({"latest_version" => "0.2.3", "latest_major_version" => "0.2"})
    end

    it "returns the expected context hash when the latest tag is a major release tag" do
      WebMock
        .stub(:get, "https://api.github.com/repos/martenframework/marten/tags")
        .to_return(
          body: <<-JSON
            [
              {
                "name": "v0.2.0",
                "zipball_url": "https://example.com",
                "tarball_url": "https://example.com",
                "commit": {
                  "sha": "12345",
                  "url": "https://example.com"
                },
                "node_id": "12345"
              },
              {
                "name": "v0.1.5",
                "zipball_url": "https://example.com",
                "tarball_url": "https://example.com",
                "commit": {
                  "sha": "12345",
                  "url": "https://example.com"
                },
                "node_id": "12345"
              }
            ]
          JSON
        )

      context_producer = Website::VersionContextProducer.new
      context_producer.produce.should eq({"latest_version" => "0.2.0", "latest_major_version" => "0.2"})
    end
  end
end
