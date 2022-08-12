require "json"
require "httparty"

module StatusCode
  
  # 2000 success
  Success = 2000

  # 5000 server error
  # 50xx server machine
  ServerError = 5000
  # 51xx logic error

  
  # 52xx database auth
  UserHaveExist = 5201 #用户已存在
  UserNotExist  = 5202
  # 53xx database data
  InvalidParams = 5301
  RecordHaveExist = 5302

end
module SafeProtect
  refine String do
    def safe
      json_parse self.strip.dump[1 .. -2]
    end

    def escape
      json_parse self.dump[1 .. -2]
    end

    def unescape
      "\"#{self}\"".undump
    end
  end
end

using SafeProtect

module Mchat

  module StatusCode
    # 2000 success
    Success = 2000

    # 5000 server error
    # 50xx server machine
    ServerError = 5000
    # 51xx logic error

    # 52xx database auth
    UserHaveExist = 5201 #用户已存在
    UserNotExist  = 5202
    # 53xx database data
    InvalidParams = 5301
    RecordHaveExist = 5302
  end

  class Request
    include HTTParty
    # TODO 读取用户文件配置
    base_uri 'localhost:4567'
    

    def initialize
      @headers = {"Accept": "application/json"}
    end

    def json_parse(resp)
      JSON.parse(resp.body)
    end

    def server_home
      json_parse self.class.get("/")
    end

    def ping_server
      json_parse self.class.get("/ping")
    end

    def get_server_timestamp
      json_parse self.class.get("/timestamp")
    end

    def conn_server_startup
      json_parse self.class.get("/startup")
    end

    def get_channels
      # 获得 channels列表
      json_parse self.class.get("/channels")
    end

    def get_channel(channel_name)
      # 获得 channels 详情
      json_parse self.class.get("/channels/#{channel_name}")
    end

    def create_channel(channel_name)
      # 创建用户频道
      json_parse self.class.post("/channels/#{channel_name}")
    end

    def delete_channel(channel_name)
      json_parse self.class.delete("/channels/#{channel_name}")
    end

    def join_channel(channel_name, user_name)
      json_parse self.class.post(
        "/channels/#{channel_name}/join",
        body: { user_name: user_name }.to_json,
        headers: @headers
      )
    end

    def leave_channel(channel_name, user_name)
      json_parse self.class.post(
        "/channels/#{channel_name}/leave",
        body: { user_name: user_name }.to_json,
        headers: @headers
      )
    end

    def ping_channel(channel_name, user_name)
      json_parse self.class.post(
        "/channels/#{channel_name}/ping",
        body: { user_name: user_name }.to_json,
        headers: @headers
      )
    end

    def create_channel_message(channel_name, user_name, content)
      json_parse self.class.post(
        "/channels/#{channel_name}/messages",
        body: { 
          user_name: user_name,
          content: content
        }.to_json,
        headers: @headers
      )
    end

    def fetch_channel_message(channel_name)
      json_parse self.class.get(
        "/channels/#{channel_name}/messages",
        headers: @headers
      )
    end
  end

  Api = ::Mchat::Request.new

end
