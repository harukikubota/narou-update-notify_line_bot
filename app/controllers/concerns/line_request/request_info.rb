require_relative './request_info/text_request_info.rb'
require_relative './request_info/follow_request_info.rb'
require_relative './request_info/postback_request_info.rb'
require_relative './request_info/none_request_info.rb'

# イベントタイプごとにリクエストインフォ処理結果クラスを作成する。
#
# # @param [type] リクエストタイプ
#          [request_data] イベント
#
class LineRequest::RequestInfo
  attr_reader :data, :user_info

  def initialize(type, request_data)
    @type = type
    create_request_info(request_data)
  end

  private

  def create_request_info(data)
    case @type
    when Constants::Request::TYPE_TEXT
      @data = TextRequestInfo.new(data)
    when Constants::Request::TYPE_FOLLOW, Constants::Request::TYPE_UNFOLLOW
      @data = FollowRequestInfo.new(data)
    when Constants::Request::TYPE_POSTBACK
      @data = PostbackRequestInfo.new(data)
    when Constants::Request::TYPE_NONE
      @data = NoneRequestInfo.new(data)
    end

    create_user_info(data)
  end

  def create_user_info(data)
    user_info_ele = Struct.new(:line_id, :reply_token)

    line_id = data['source']['userId']
    reply_token = data['replyToken']

    @user_info = user_info_ele.new(line_id, reply_token)
  end
end
