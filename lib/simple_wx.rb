# encoding: utf-8
require 'redis'
require 'yell'

module SimpleWx
  @@weixin_config = {}
  @@logger = Yell.new :datefile, 'simple_wx.log'
  @@redis  = Redis.new(host: '127.0.0.1', port: '6379', db: '0')

  def self.weixin_config
    @@weixin_config
  end

  def self.logger
    @@logger
  end

  def self.redis
    @@redis
  end
end

require 'simple_wx/base'
require 'simple_wx/signaturer'
require 'simple_wx/o_auth'
require 'simple_wx/access_token'
require 'simple_wx/menu'
require 'simple_wx/user_info'
require 'simple_wx/message'
require 'simple_wx/messages/text_message'
require 'simple_wx/messages/image_message'
require 'simple_wx/messages/news_message'
require 'simple_wx/messages/video_message'
require 'simple_wx/messages/voice_message'
require 'simple_wx/messages/music_message'

