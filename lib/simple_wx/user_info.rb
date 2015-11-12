module SimpleWx
  class UserInfo < Base

    ### Usage
    #
    # ---------- class-methods ----------
    #
    # instance_of_oauth = SimpleWx::OAuth.new("code")
    # instance_of_oauth.get_access_token
    # user_info_hsh = SimpleWx::UserInfo.get_auth_info(o_auth: instance_of_oauth)
    #
    # user_info_hsh = SimpleWx::UserInfo.get_basic_info(access_token: "token", openid: "openid")
    #
    # ---------- instance-methods -----------
    #
    # @user_info = SimpleWx::UserInfo.new(access_token: "token", openid: "openid")
    # user_info_hsh = @user_info.get_basic_info
    # if @user_info.error.present?
    #   ...
    # end
    #

    def initialize options
      @openid = options[:openid]
      @o_auth = options[:o_auth]
      @access_token = options[:access_token] || AccessToken.access_token
    end

    def get_basic_info
      url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{@access_token}&openid=#{@openid}&lang=zh_CN"
      response = RestClient.get url
      errcode_check(JSON.parse(response))
    end

    def get_auth_info
      url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{@o_auth.access_token}&openid=#{@o_auth.openid}&lang=zh_CN"
      response = RestClient.get url
      errcode_check(JSON.parse(response))
    end

    def self.method_missing m, hsh
      if instance_methods.include? m.to_sym
        self.new(hsh).send m
      else
        super
      end
    end
  end
end