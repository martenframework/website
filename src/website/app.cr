require "./handlers/**"
require "./routes"

module Website
  class App < Marten::App
    label :website
  end
end
