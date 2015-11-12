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
      @timestamp = options.fetch :timestamp
      @nonce     = options.fetch :nonce
      @token     = SimpleWx.weixin_config["token"] #TODO 没有就raise错误,用method_missing
    end

    def sign signture
      @sort_array = [@timestamp, @nonce, @token].sort
      signture == sha1_encrypt
    end

    private

    def sha1_encrypt
      encrypt_str = @sort_array.join
      Digest::SHA1.hexdigest(encrypt_str)
    end
  end
end
