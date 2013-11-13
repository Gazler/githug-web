require 'sinatra'
require 'securerandom'

get '/' do
  id = SecureRandom.hex(3)
  build = `docker build -t "githug#{id}" .`.chomp
  @password = build.split("\n").grep(/FINDME/)[-1].split(" ")[-1]
  container_id = `docker run -p 22 -d -t "githug#{id}"`.chomp
  @port = `docker port #{container_id} 22`.chomp.split(":")[-1]
  erb :index
end
