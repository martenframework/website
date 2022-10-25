module Website
  class GoogleSiteVerificationCodeContextProducer < Marten::Template::ContextProducer
    def produce(request : Marten::HTTP::Request? = nil)
      {"google_site_verification_code" => Marten.settings.website.google_site_verification_code}
    end
  end
end
