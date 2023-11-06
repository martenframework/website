require "socket/ip_socket"

Marten.configure :development do |config|
  config.debug = true

  config.assets.dirs = [
    Path["src/website/assets/build_dev"].expand,
    Path["src/website/assets"].expand,
  ]

  tmp_stdout = IO::Memory.new
  Process.run("lsof -i:8080", shell: true, output: tmp_stdout)

  if !tmp_stdout.rewind.gets_to_end.empty?
    config.assets.url = "http://localhost:8080/assets/"
  end
end
