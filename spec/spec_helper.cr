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

Spec.before_each &->WebMock.reset
Spec.before_each do
  Marten.templates.context_producers
    .find(&.is_a?(Website::VersionContextProducer))
    .try do |context_producer|
      context_producer.as(Website::VersionContextProducer).version_data = {
        "latest_version"       => "0.1.1",
        "latest_major_version" => "0.1",
      }
    end
end
