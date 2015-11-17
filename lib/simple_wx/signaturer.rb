require 'securerandom'
module SimpleWx
  class Signaturer < Base

    ### Usage
    #
    # signer = SimpleWx::Signaturer.new timestamp: params[:timestamp], nonce: params[:nonce]
    # if signer.sign params[:signature]
    #   render text: params[:echostr]
    # else
    #   ...
    # end

    def initialize options = {}
      @timestamp = options[:timestamp] || Time.now.to_i
      @nonce     = options[:nonce]     || SecureRandom.urlsafe_base64
      @token     = SimpleWx.weixin_config["token"] #TODO 没有就raise错误,用method_missing
    end

    def sign signture
      @sort_array = [@timestamp, @nonce, @token].sort
      encrypt_str = @sort_array.join
      signture == sha1_encrypt(encrypt_str)
    end

    def jsapi_signature_gen url
      params = {
        'jsapi_ticket' => AccessToken.jsapi_ticket,
        'noncestr' => @nonce,
        'timestamp' => @timestamp,
        'url' => url.split('#', 2).first
      }
      params = Hash[params.sort]
      encrypt_str = params.to_a.map { |a, b| "#{a}=#{b}" }.join('&')
      signature = sha1_encrypt(encrypt_str)
      {
        'appId' => SimpleWx.weixin_config["app_id"],
        'timestamp' => @timestamp,
        'nonceStr' => @nonce,
        'signature' => signature
      }
    end

    def self.jsapi_signature_gen options
      url = options.delete(:url)
      self.new(options).jsapi_signature_gen url
    end

    private

    def sha1_encrypt encrypt_str
      Digest::SHA1.hexdigest(encrypt_str)
    end
  end
end
