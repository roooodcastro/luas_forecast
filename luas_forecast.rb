#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

class LuasForecast
  attr_reader :stop, :line_status, :inbound_trams, :outbound_trams, :stop_name

  API_URL = 'http://luasforecasts.rpa.ie/xml/get.ashx?encrypt=false&stop=STOPID&action=forecast'

  def initialize(stop_code)
    @stop = stop_code
    fetch
  end

  def to_h
    {
      stop_name: stop_name,
      status: line_status,
      inbound: inbound_trams,
      outbound: outbound_trams
    }
  end

  private

  def fetch
    stop_url = API_URL.gsub('STOPID', stop.to_s)

    xml = Nokogiri::XML(open(stop_url)).document

    @line_status = xml.xpath('//stopInfo').text
    @stop_name = xml.xpath('//stopInfo').attribute('stop').text

    @inbound_trams = xml.xpath("//direction[@name='Inbound']").children.map(&:to_h)
    @outbound_trams = xml.xpath("//direction[@name='Outbound']").children.map(&:to_h)
  end
end
