module SimpleWx
  class Message < Base
    attr_accessor :openid, :json, :xml
    def initialize options
      @openid = options[:openid]
      @access_token = options[:access_token] || AccessToken.access_token
      @custom_msg_url = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=#{@access_token}"
      @json = {}
      @xml = {}
    end

    protected

    def set_json
      @json[:touser]  = @openid
    end

    def set_xml
      @xml["ToUserName"]   = @openid
      @xml["FromUserName"] = SimpleWx.weixin_config["serial_no"]
      @xml["CreateTime"]   = Time.now.to_i.to_s
    end

    def send_json
      set_json
      response = RestClient.post(@custom_msg_url, JSON.generate(@json))
      errcode_check(JSON.parse(response))
    end

    def send_json!
      @raise_flag ||= true
      send_json
    end

    def to_xml
      set_xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.xml do
          recursively_xml xml, @xml
        end
      end
      builder.to_xml
    end

    private

    def recursively_xml builder, hsh
      hsh.each do |k, v|
        if v.is_a? Hash
          builder.send(k) do
            recursively_xml(builder, v)
          end
        elsif v.is_a? Array
          builder.send(k) do
            v.each do |item|
              recursively_xml(builder, item)
            end
          end
        else
          builder.send(k, v)
        end
      end
    end
  end
end
