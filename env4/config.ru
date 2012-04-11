app = proc do |env|
  request = Rack::Request.new(env)
  sleep 1 if request.host == 'test2.com'
  [ 200, {'Content-Type' => 'text/plain'}, ['OK'] ]
end

run app
