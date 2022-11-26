module Website
  class ChatHandler < Marten::Handlers::Redirect
    def redirect_url
      Marten.settings.website.discord_invitation_link
    end
  end
end
