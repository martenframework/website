require "./spec_helper"

describe Website::GoogleSiteVerificationCodeContextProducer do
  describe "#produce" do
    it "returns a hash including the Google site verification code" do
      context_producer = Website::GoogleSiteVerificationCodeContextProducer.new
      context_producer.produce.should eq(
        {"google_site_verification_code" => Marten.settings.website.google_site_verification_code}
      )
    end
  end
end
