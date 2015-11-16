
# SimpleWx

Ruby Api for Micro Message（WeiXin 微信）Public（公众）Platform.

[微信公众平台开发文档](http://mp.weixin.qq.com/wiki/home/index.html)

------

## Installation

### Step 1

Add this line to your application's Gemfile:

```ruby
  gem 'simple_wx'
```

### Step 2

在 `config/initailizers/` 目录下添加文件 `simple_wx.rb`:

```ruby
  module SimpleWx
    # 配置微信参数
    # 配置日志对象
    # 配置 Redis，用来存放 access_token 和 jsapi_ticket

    # @@weixin_config = YAML.load_file(File.join "#{Rails.root}", "config", "weixin.yml")
    @@weixin_config = { "app_id"=>"app_id",
                        "app_secret"=>"app_secret",
                        "serial_no"=>"gh_xxxxxxxx(微信号)",
                        "token"=>"verify_token"
                      }
    @@logger = Rails.logger
    @@redis  = Redis::Objects.redis
  end
```

### Optional

选择配置 `config/weixin.yml`:

```ruby
  development:
    app_id: app_id
    app_secret: app_secret
    serial_no: 微信号 (gh...)
    token: token

  production:
    # ...
```

配置 helper 方法，生成 jsapi 签名参数 `application_helper.rb`:

```ruby
  def weixin_jsapi_signature_params
    SimpleWx::Signaturer.jsapi_signature_gen url: url
  end
```

------

## Usage

### Signaturer

验证微信消息签名

```ruby
  signer = SimpleWx::Signaturer.new timestamp: params[:timestamp], nonce: params[:nonce]
  if signer.sign params[:signature]
    render text: params[:echostr]
  else
    # ...
  end
```

生成 jsapi 签名参数

```ruby
  SimpleWx::Signaturer.jsapi_signature_gen url: url
```

------

### AccessToken

保存在 Redis 中，保存 30 mins

get access_token

```ruby
  SimpleWx::AccessToken.access_token
```

get 微信服务器ip

```ruby
  SimpleWx::AccessToken.server_ip
```

get jsapi_ticket

```ruby
  SimpleWx::AccessToken.jsapi_ticket
```

------

### Menu

查看、生成、删除菜单，buttons 参数为 hash，格式参照微信文档

```ruby
   SimpleWx::Menu.show
   SimpleWx::Menu.create(buttons)  # 返回 true/false
   SimpleWx::Menu.create!(buttons) # 强制报错
   SimpleWx::Menu.delete           # 返回 true/false
   SimpleWx::Menu.delete!
```

------

### OAuth

生成微信回调链接

```ruby
  SimpleWx::OAuth.generate_auth_link "url", "state", "snsapi_userinfo/snsapi_base"
```

获取 `OAuth` 的 `access_token` 及相关参数

```ruby
  auth = SimpleWx::OAuth.new(code: "code")
  result_json = auth.get_access_token
```

`access_token` 返回的基本参数会赋值给实例属性

```ruby
  auth.access_token == result_json["access_token"]
  # => true
```

检查 `access_token` 是否过期

```ruby
  auth.access_token_valid?
  => true/false
```

查看 `access_token` 过期时间

```ruby
  auth.expires_in
  # => 7200
```

刷新 `access_token`

```ruby
  result_json = auth.refresh_token
  auth.access_token == result_json["access_token"]
  auth.access_token_valid?
  # => true
```

通过 OAuth 信息获取用户信息，返回信息格式见微信文档

```ruby
  auth.get_user_info
```

__第三方登录获取user_info__

```ruby
  auth = SimpleWx::OAuth.new(access_token: "o_auth_access_token", openid: "openid")
  auth.get_user_info
```

------

### UserInfo

获取用户信息一般接口

```ruby
  @user_info = SimpleWx::UserInfo.new(access_token: "token", openid: "openid")
```

获取用户信息 OAuth 接口

```ruby
  o_auth = SimpleWx::OAuth.new("code")
  o_auth.get_access_token
  SimpleWx::UserInfo.get_auth_info(o_auth: o_auth)
```

------

### Message

通过客服接口发送

```ruby
  message_params = {openid: "to_user", content: "content"}
  SimpleWx::Messages::TextMessage.send_json!(message_params)
  SimpleWx::Messages::TextMessage.send_json(message_params)
```

直接返回给微信

```ruby
  message_params = {openid: "to_user", content: "content"}
  render xml: SimpleWx::Messages::TextMessage.to_xml(message_params)
```

使用对象方式

```ruby
  msg = SimpleWx::Messages::TextMessage.new openid: "to_user", content: "content"
  msg.send_json
  msg.to_xml
```

信息对象列举：

```ruby
  msg = SimpleWx::Messages::TextMessage.new openid: "to_user", content: "content"
  msg = SimpleWx::Messages::ImageMessage.new openid: "to_user", media_id: "media_id"
  msg = SimpleWx::Messages::VoiceMessage.new openid: "to_user", media_id: "media_id"
  video = { title: 'title', media_id: 'media_id', description: 'desc' }
  msg = SimpleWx::Messages::VideoMessage.new openid: "to_user", video: video

  music = { title: 'title', description: 'desc', music_url: 'url', hq_music_url: 'hq_url', thumb_media_id: 'thumb_media_id' }
  msg = SimpleWx::Messages::MusicMessage.new openid: "to_user", music: music

  # 图文信息必须使用数组包围
  articles = [{title: 'title1', description: 'desc1', url: 'url1', picurl: 'picurl1'}, {title: 'title2', ..., picurl: 'picurl2'}, ...]
  msg = SimpleWx::Messages::NewsMessage.new openid: "to_user", articles: articles
```

------

### Template

改变行业id

```ruby
  SimpleWx::Template.set_industry id1, id2
```

获取模板id

```ruby
  SimpleWx::Template.get_template_id(template_id_short: "TM00015")
```

发送模板信息

```ruby
  params = {
    openid: openid,
    template_id: "JrneF1SO3wo1K3qG1GL-zplmJpvxFsrIeBWPFYKIBB4",
    url: open_url,
    topcolor: "#FF0000",
    data: {
      ...
    }
  }
  SimpleWx::Template.send_json(params)
```

------

### Media

获取临时素材

```ruby
  SimpleWx::Media.get_media(media_id: "media_id")
```

获取永久素材

```ruby
  SimpleWx::Media.get_material(media_id: "media_id")
```

------

### Base

上面所有的方法都能使用__类方法__和__实例方法__实现。
使用实例的方式，能获得一个 error 参数，检查微信接口是否有错误码返回。
error 在每次请求微信API时都会刷新.

eg.

```ruby
  at = SimpleWx::AccessToken.new
  at.access_token
  if at.error.present?
    ...
  end
```

------
