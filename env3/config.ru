class LivetrafficMockMiddleware 
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    env['rack.livetraffic_id'] = 'test2' if request.host == 'test2.com'
    @app.call(env)
  end
end

use LivetrafficMockMiddleware

app = proc do |env|
  [ 200, {'Content-Type' => 'text/plain'}, ['OK'] ]
end

run app
