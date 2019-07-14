require_relative '../../../lib/line_request/line_message/element/button_element.rb'

class WriterDelete < TextCommand
  def initialize(user_info, request_info)
    super
  end

  def call
    writer_id = @request_info.data.match(/[0-9]{1,4}/).to_s
    return self, @success = true if writer_id == '0'

    name = Writer.find(writer_id).name

    if delete_ucn = UserCheckWriter.where(writer_id: writer_id).first
      delete_ucn.destroy
      @message = reply_deleted(name)
    else
      @message = reply_already_deleted(name)
    end
    @success = true
  end

  def reply_deleted(writer_name)
    <<~MES.chomp
      「#{writer_name}」の新規投稿監視を削除しました。
    MES
  end

  def reply_already_deleted(writer_name)
    <<~MES.chomp
      「#{writer_name}」の新規投稿監視はすでに削除されています。
    MES
  end
end