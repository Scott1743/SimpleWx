module SimpleWx
  class OAuth < Base

    ### Usage
    #
    # auth = SimpleWx::OAuth.new(code: "code")
    #
    # 调用 OAth2 的 access_token 接口, 返回结果信息
    # result_json = auth.get_access_token
    #
    # auth 返回的基本参数会赋值给对象属性
    # auth.access_token == result_json["access_token"]
    # => true
    #
    # 检查 access_token 是否过期
    # auth.access_token_valid?
    # => true
    #
    # auth.expires_in
    # => 7200
    # sleep 7201
    # auth.access_token_valid?
    # => false
    #
    # 刷新access_token接口
    # result_json = auth.refresh_token
    # auth.access_token == result_json["access_token"]
    # auth.access_token_valid?
    # => true
    #

    attr_reader :code, :scope, :expires_in, :unionid, :result
    attr_accessor :access_token, :refresh_token, :openid

    def initialize options
      @code = options[:code]
    end

    def get_access_token
      url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{SimpleWx.weixin_config["app_id"]}&secret=#{SimpleWx.weixin_config["app_secret"]}&code=#{@code}&grant_type=authorization_code"
      response = RestClient.get url
      set_result(errcode_check(JSON.parse(response)))
    end

    def get_user_info
      if @scope == "snsapi_base"
        UserInfo.get_base_info(openid: @openid)
      else
        UserInfo.get_auth_info(o_auth: self)
      end
    end

    def access_token_valid?
      url = "https://api.weixin.qq.com/sns/auth?access_token=#{@access_token}&openid=#{@openid}"
      response = RestClient.get url
      errcode_check(JSON.parse(response))
      @error.blank?
    end

    def refresh_token
      url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=#{SimpleWx.weixin_config["app_id"]}&grant_type=refresh_token&refresh_token=#{@refresh_token}"
      response = RestClient.get url
      set_result(errcode_check(JSON.parse(response)))
    end

    def self.generate_auth_link url, state = "", scope = "snsapi_userinfo"
      params = {
        appid: SimpleWx.weixin_config["app_id"],
        redirect_uri: url,
        response_type: "code",
        scope: scope,
        state: state
      }
      "https://open.weixin.qq.com/connect/oauth2/authorize?#{params.to_query}#wechat_redirect"
    end

    private

    def set_result result
      result.each do |k, v|
        instance_variable_set "@#{k}", v
      end
      @result = result
    end
  end
end
