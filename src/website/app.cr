require "./context_producers/**"
require "./handlers/**"
require "./models/**"
require "./routes"
require "./settings"

module Website
  class App < Marten::App
    label :website
  end
end
