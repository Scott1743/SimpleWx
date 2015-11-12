module SimpleWx
  module Messages
    class TextMessage < Message
      def initialize options
        super
        @content = options[:content]
      end

      def send_json
        @json[:msgtype] = "text"
        @json[:text] = {content: @content}
        SimpleWx.logger.info("SimpleWxLog:#{self.class.name} -- #{@openid} -- #{json}")
        super
      end

      def to_xml
        @xml["MsgType"] = "text"
        @xml["Content"] = @content
        super
      end
    end
  end
end