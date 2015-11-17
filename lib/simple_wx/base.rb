module SimpleWx
  class Base
    attr_accessor :error, :raise_flag

    def initialize options = {}
      raise 'SimpleWx.weixin_config is blank.' if SimpleWx.weixin_config.empty?
      @raise_flag = options[:raise_flag]
      @log_flag = options[:log_flag]
      @error = {}
    end

    def self.method_missing m, *args
      if public_instance_methods(false).include? m.to_sym
        self.new(*args).send(m)
      else
        super
      end
    end

    protected

    def errcode_check json, log_flag = nil

      # 每次执行刷新 @error
      # 根据 log_flag 打印日志
      # 检查是否直接抛错

      @error = {}
      raise "Responsed nothing from Weixin" if json.nil? && @raise_flag
      if !json["errcode"].nil? && json["errcode"].to_i != 0
        SimpleWx.logger.error(json)
        @error = json
        raise "Weixin response json with errcode: #{json}" if @raise_flag
      else
        if log_flag
          SimpleWx.logger.info("SimpleWxLog:#{self.class.name} -- #{log_flag} -- #{json}")
        else
          SimpleWx.logger.debug("SimpleWxLog:#{self.class.name} -- #{json}")
        end
      end
      json
    end

  end
end