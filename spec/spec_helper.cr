ENV["MARTEN_ENV"] = "test"

require "spec"
require "marten"
require "marten/spec"

require "../src/project"
require "./ext/**"

Log.setup(:error)

Raven.configure do |config|
  config.dsn = "dummy://12345:67890@sentry.localdomain:3000/sentry/42"
end
