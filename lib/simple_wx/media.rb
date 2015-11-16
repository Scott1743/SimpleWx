module SimpleWx
  class Media < Base
    def initialize options
      @access_token = options[:access_token] || AccessToken.access_token
      @media_id = options[:media_id]
    end

    def get_media
      url = "https://api.weixin.qq.com/cgi-bin/media/get?access_token=#{@access_token}&media_id=#{@media_id}"
      RestClient.get url
    end

    def get_material
      url = "https://api.weixin.qq.com/cgi-bin/material/get_material?access_token=#{@access_token}"
      response = RestClient.post(url, JSON.generate(media_id: @media_id))
      errcode_check(JSON.parse(response))
    end
  end
end
