module SimpleWx
  module Messages
    class VideoMessage < Message
      def initialize options
        super
        @video = options[:video]
      end

      def send_json
        @json[:msgtype] = "video"
        @json[:video] = @video
        SimpleWx.logger.info("SimpleWxLog:#{self.class.name} -- #{@openid} -- #{json}")
        super
      end

      def to_xml
        @xml["MsgType"] = "video"
        @xml["Video"] = {
          "MediaId"     => @video[:media_id],
          "Title"       => @video[:title],
          "Description" => @video[:description],
        }
        super
      end
    end
  end
end

