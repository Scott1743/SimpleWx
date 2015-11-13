module SimpleWx
  module Messages
    class NewsMessage < Message
      def initialize options
        super
        @articles = options[:articles]
      end

      def send_json
        @json[:msgtype] = "news"
        @json[:news] = { articles: @articles }
        SimpleWx.logger.info("SimpleWxLog:#{self.class.name} -- #{@openid} -- #{json}")
        super
      end

      def to_xml
        @xml["MsgType"] = "news"
        @xml["News"] = { "Articles" => @articles }
        super
      end
    end
  end
end
