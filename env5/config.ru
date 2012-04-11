class StripFaviconMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    return [ 200, {'Content-Type' => 'text/plain'}, ['OK'] ]  if request.path == "/favicon.ico"
    @app.call(env)
  end
end

use StripFaviconMiddleware

app = proc do |env|
  [ 200, {'Content-Type' => 'text/plain'}, ['OK'] ]
end

run app
