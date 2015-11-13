module SimpleWx
  module Messages
    class MusicMessage < Message
      def initialize options
        super
        @title = options[:title]
        @desc = options[:desc]
        @music_url = options[:music_url]
        @hq_music_url = options[:hq_music_url]
        @thumb_media_id = options[:thumb_media_id]
      end

      def send_json
        @json[:msgtype] = "music"
        @json[:music] = {
          title:           @title,
          descrition:      @desc,
          musicurl:        @music_url,
          hqmusicurl:      @hq_music_url,
          thumb_media_id:  @thumb_media_id
        }
        SimpleWx.logger.info("SimpleWxLog:#{self.class.name} -- #{@openid} -- #{json}")
        super
      end

      def to_xml
        @xml["MsgType"] = "music"
        @xml["Image"] = {
          "Title"        => @title,
          "Descrition"   => @desc,
          "MusicUrl"     => @music_url,
          "HQMusicUrl"   => @hq_music_url,
          "ThumbMediaId" => @thumb_media_id
        }
        super
      end
    end
  end
end

