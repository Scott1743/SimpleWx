require "rspec"
require "simple_wx"
require "pry"
require "pry-nav"

module RestClient
  def self.get(url, headers={}, &block)
    Request.execute(:method => :get, :url => url, :headers => headers, :verify_ssl => false, &block)
  end

  def self.post(url, payload, headers={}, &block)
    Request.execute(:method => :post, :url => url, :payload => payload, :headers => headers, :verify_ssl => false,&block)
  end
end

module SimpleWx
  @@weixin_config = {
    "app_id"=>"wx59326fb0b1303158",
    "app_secret"=>"b1fc68461fe0619898620d57e6dd00dd",
    "serial_no"=>"gh_94948c8e641f",
    "token"=>"danchedianying"
  }
end

RSpec.configure do |config|
end