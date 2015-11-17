module SimpleWx
  class Menu < Base

    ### Usage
    #
    # ---------- class-methods ----------
    #
    # SimpleWx::Menu.show
    # SimpleWx::Menu.create(buttons)
    # => true/false
    # SimpleWx::Menu.delete
    # => true/false
    #
    # ---------- instance-methods -----------
    #
    # menu = SimpleWx::Menu.new
    # menu.show
    #
    # if menu.create(buttons)
    #   ...
    # else
    #  p menu.error
    # end
    #
    # menu.delete!
    # when "errcode" existed in json of response, it will raise the error:
    # => "Weixin response json with errcode: #{json}"
    #

    def initialize options = {}
      @access_token = options[:access_token] || AccessToken.access_token
    end

    def show
      url = "https://api.weixin.qq.com/cgi-bin/menu/get?access_token=#{@access_token}"
      response = RestClient.get url
      errcode_check(JSON.parse(response))
    end

    def create menu_hash
      url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{@access_token}"
      response = RestClient.post(url, JSON.generate({button: menu_hash}))
      errcode_check(JSON.parse(response))
      @error.empty?
    end

    def delete
      url = "https://api.weixin.qq.com/cgi-bin/menu/delete?access_token=#{@access_token}"
      response = RestClient.get url
      errcode_check(JSON.parse(response))
      @error.empty?
    end

    def create! menu_hash
      @raise_flag ||= true
      create menu_hash
    end

    def delete!
      @raise_flag ||= true
      delete
    end
  end
end