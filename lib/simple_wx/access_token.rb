module SimpleWx
  class AccessToken < Base

    ### Usage
    #
    # ---------- class-methods ----------
    #
    # SimpleWx::AccessToken.access_token
    # SimpleWx::AccessToken.server_ip
    # SimpleWx::AccessToken.jsapi_ticket
    #
    # ---------- instance-methods -----------
    #
    # at = SimpleWx::AccessToken.new
    # at.access_token
    # at.server_ip
    # if at.error.present?
    #   ...
    # end
    #


    def server_ip
      url = "https://api.weixin.qq.com/cgi-bin/getcallbackip?access_token=#{access_token}"
      response = RestClient.get url
      response_json = errcode_check(JSON.parse(response))
      @server_ip = response_json["ip_list"]
    end

    def access_token
      SimpleWx.redis.exists("__weixin_access_token__") ? \
      SimpleWx.redis.get("__weixin_access_token__") : get_new_token
    end

    def jsapi_ticket
      SimpleWx.redis.exists("__jsapi_ticket__") ? \
      SimpleWx.redis.get("__jsapi_ticket__") : get_new_jsapi_ticket
    end

    private

    def get_new_jsapi_ticket
      url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{access_token}&type=jsapi"
      response = RestClient.get url
      response_json = errcode_check(JSON.parse(response))
      jsapi_ticket = response_json["ticket"]
      if @error.blank?
        SimpleWx.redis.multi do
          SimpleWx.redis.set "__jsapi_ticket__", jsapi_ticket
          SimpleWx.redis.expire "__jsapi_ticket__", 30.minutes.to_i
        end
      end
      jsapi_ticket
    end

    def get_new_token
      url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{SimpleWx.weixin_config["app_id"]}&secret=#{SimpleWx.weixin_config["app_secret"]}"
      response = RestClient.get url
      response_json = errcode_check(JSON.parse(response))
      access_token = response_json["access_token"]
      if @error.blank?
        SimpleWx.redis.multi do
          SimpleWx.redis.set "__weixin_access_token__", access_token
          SimpleWx.redis.expire "__weixin_access_token__", 30.minutes.to_i
        end
      end
      access_token
    end

    def self.method_missing m
      instance = self.new
      if instance.public_methods(false).include? m.to_sym
        return instance.send(m)
      else
        super
      end
    end
  end
end