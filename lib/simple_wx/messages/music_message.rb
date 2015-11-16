module SimpleWx
  module Messages
    class MusicMessage < Message
      def initialize options
        super
        @music = options[:music]
      end

      def send_json
        @json[:msgtype] = "music"
        @json[:music] = @music
        SimpleWx.logger.info("SimpleWxLog:#{self.class.name} -- #{@openid} -- #{json}")
        super
      end

      def to_xml
        @xml["MsgType"] = "music"
        @xml["Music"] = {
          "Title"        => @music[:title],
          "Description"  => @music[:description],
          "MusicUrl"     => @music[:music_url],
          "HQMusicUrl"   => @music[:hq_music_url],
          "ThumbMediaId" => @music[:thumb_media_id]
        }
        super
      end
    end
  end
end

