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
          "published_at": "2022-10-24T23:44:21Z"
        }
      ]
    JSON
    )
end
