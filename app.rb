
require 'rack'
require 'pry'
require 'json'
require './luas_forecast'

class App
  def call(env)
    req = Rack::Request.new(env)
    
    stop = req.params['stop']

    if stop
      forecast = LuasForecast.new(stop)
      [200, { 'Content-Type' => 'text/json'}, [forecast.to_h.to_json]]
    else
      [404, { 'Content-Type' => 'text/json'}, [{ error: 'A stop name must be provided!' }.to_json]]
    end
  end
end
