## initializers/simple_wx.rb:
```
  WeixinSetting = YAML.load_file(File.join "#{Rails.root}", "config", "weixin.yml")[Rails.env || "development"]

  module SimpleWx
    @@weixin_config = YAML.load_file(File.join "#{Rails.root}", "config", "weixin.yml")[Rails.env || "development"]
    @@logger = Rails.logger
    @@redis  = Redis::Objects.redis
  end
```

## config/weixin.yml:
```
  development:
    app_id: app_id
    app_secret: app_secret
    serial_no: 微信号 (gh...)
    token: token

  production:
    # ...
```