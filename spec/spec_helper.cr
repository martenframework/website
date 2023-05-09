ENV["MARTEN_ENV"] = "test"

require "spec"
require "marten"
require "marten/spec"
require "webmock"

require "../src/project"
require "./ext/**"

Log.setup(:error)

Raven.configure do |config|
  config.dsn = "dummy://12345:67890@sentry.localdomain:3000/sentry/42"
end

Spec.before_each do
  WebMock.reset

  WebMock
    .stub(:get, "https://api.github.com/repos/martenframework/marten/tags")
    .to_return(
      body: <<-JSON
      [
        {
          "name": "v0.1.3",
          "zipball_url": "https://example.com",
          "tarball_url": "https://example.com",
          "commit": {
            "sha": "12345",
            "url": "https://example.com"
          },
          "node_id": "12345"
        },
        {
          "name": "v0.1.2",
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
end
