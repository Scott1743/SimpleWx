module SimpleWx
  module Messages
    class VideoMessage < Message
      def initialize options
        super
        @title = options[:title]
        @desc = options[:desc]
        @media_id = options[:media_id]
        @thumb_media_id = options[:thumb_media_id]
      end

      def send_json
        @json[:msgtype] = "video"
        @json[:music] = {
          media_id:        @media_id,
          thumb_media_id:  @thumb_media_id,
          title:           @title,
          descrition:      @desc
        }
        SimpleWx.logger.info("SimpleWxLog:#{self.class.name} -- #{@openid} -- #{json}")
        super
      end

      def to_xml
        @xml["MsgType"] = "video"
        @xml["Video"] = {
          "MediaId"    => @media_id,
          "Title"      => @title,
          "Descrition" => @desc,
        }
        super
      end
    end
  end
end

