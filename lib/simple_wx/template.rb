module SimpleWx
  class Template < Message
    attr_reader :template_id

    def initialize options
      super
      @access_token = options[:access_token] || AccessToken.access_token
      @template_id_short = options[:template_id_short]
      @template_id = options[:template_id]
      @url = options[:url]
      @topcolor = options[:topcolor]
      @data = options[:data]
    end

    undef_method :to_xml

    def get_template_id
      url = "https://api.weixin.qq.com/cgi-bin/template/api_add_template?access_token=#{@access_token}"
      response = RestClient.post(url, JSON.generate({template_id_short: @template_id_short}))
      response_json = errcode_check(JSON.parse(response))
      @template_id = response_json["template_id"]
    end

    def send_json
      set_json
      @json["template_id"] = @template_id
      @json["url"] = @url
      @json["topcolor"] = @topcolor
      @json["data"] = @data
      url = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=#{@access_token}"
      response = RestClient.post(url, JSON.generate(@json))
      errcode_check(JSON.parse(response))
    end

    def self.set_industry id1 ,id2
      url = "https://api.weixin.qq.com/cgi-bin/template/api_set_industry?access_token=#{@access_token}"
      response = RestClient.post(url, JSON.generate({industry_id1: id1, industry_id2: id2}))
      errcode_check(JSON.parse(response))
    end
  end
end


