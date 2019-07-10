class RequestInfo

  def initialize(type, request_data)
    @type = type
    @request_data = request_data
    build_request_info
  end

  def type
    @type
  end

  def user_info
    @user_info
  end

  def data
    @data
  end

  def user_send_text
    @text
  end

  private

  def build_request_info
    case @type
    when Constants::Request::TYPE_TEXT
      @text = @request_data.message['text']
      @type = request_type_by_text
    when Constants::Request::TYPE_FOLLOW, Constants::Request::TYPE_UNFOLLOW
      #no-op
    when Constants::Request::TYPE_POSTBACK
      @data = @request_data['postback']['data']
      @type = request_type_by_postback
    end

    create_user_info
  end

  def create_user_info
    user_info_ele = Struct.new(:line_id, :reply_token)

    line_id = @request_data['source']['userId']
    reply_token = @request_data['replyToken']

    @user_info = user_info_ele.new(line_id, reply_token)
  end

  def request_type_by_text
    case @text
    when Constants::REG_LINE_REQUEST_MESSAGE
      Constants::Request::TYPE_TEXT_LINE_REQUEST
    when Constants::REG_NAROU_URL
      Constants::Request::TYPE_TEXT_ADD_NOVEL
    when Constants::REG_DELETE_COMMAND
      Constants::Request::TYPE_TEXT_DELETE
    when Constants::REG_INFO_COMMAND
      Constants::Request::TYPE_TEXT_INFO
    when Constants::REG_HELP_COMMAND
      Constants::Request::TYPE_TEXT_HELP
    when Constants::REG_LIST_COMMAND
      Constants::Request::TYPE_TEXT_LIST
    when Constants::REG_DEBUG_COMMAND
      Rails.env != 'development' ? Constants::Request::TYPE_NONE : Constants::Request::TYPE_TEXT_DEBUG
    else
      Constants::Request::TYPE_NONE
    end
  end

  def request_type_by_postback
    case @data
    when /action=delete/
      Constants::Request::TYPE_POSTBACK_NOVEL_DELETE
    end
  end
end