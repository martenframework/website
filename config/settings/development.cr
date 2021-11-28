require "socket"

Marten.configure :development do |config|
  config.debug = true

  config.assets.dirs = [
    Path["src/website/assets/build_dev"].expand,
    Path["src/website/assets"].expand,
  ]

  webpack_sock = Socket.tcp(Socket::Family::INET)
  begin
    webpack_sock.bind("localhost", 8080)
  rescue Socket::BindError
    config.assets.url = "http://localhost:8080/assets/"
  end
  webpack_sock.close
end
