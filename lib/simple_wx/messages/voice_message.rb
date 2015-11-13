module SimpleWx
  module Messages
    class VoiceMessage < Message
      def initialize options
        super
        @media_id = options[:media_id]
      end

      def send_json
        @json[:msgtype] = "voice"
        @json[:voice] = { media_id: @media_id }
        SimpleWx.logger.info("SimpleWxLog:#{self.class.name} -- #{@openid} -- #{json}")
        super
      end

      def to_xml
        @xml["MsgType"] = "voice"
        @xml["Voice"] = { "MediaId" => @media_id }
        super
      end
    end
  end
end
