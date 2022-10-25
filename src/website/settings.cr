require "./handlers/**"
require "./routes"

module Website
  class Settings < Marten::Conf::Settings
    namespace :website

    getter google_site_verification_code

    setter google_site_verification_code

    def initialize
      @google_site_verification_code = "notset"
    end
  end
end
