require "./handlers/**"
require "./routes"

module Website
  class Settings < Marten::Conf::Settings
    namespace :website

    getter discord_invitation_link
    getter google_site_verification_code

    setter discord_invitation_link
    setter google_site_verification_code

    def initialize
      @discord_invitation_link = "notset"
      @google_site_verification_code = "notset"
    end
  end
end
