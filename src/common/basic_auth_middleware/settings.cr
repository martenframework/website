class BasicAuthMiddleware < Marten::Middleware
  class Settings < Marten::Conf::Settings
    namespace :basic_auth

    getter username
    getter password

    setter username
    setter password

    def initialize
      @username = "insecure"
      @password = "insecure"
    end
  end
end
