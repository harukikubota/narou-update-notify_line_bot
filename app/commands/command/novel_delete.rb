class NovelDelete < Command
  def initialize(user_info, request_info)
    super
  end

  def call
    @message = Constants::REPLY_MESSAGE_DELETE
    @success = true
  end

  def reply_delete
    <<~MES.chomp
      【登録の削除】

      現在未対応です。
    MES
  end
end