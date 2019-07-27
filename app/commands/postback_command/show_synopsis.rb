class ShowSynopsis < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @novel = Novel.find(@params['novel_id'])
    @message = LineMessage.build_by_single_message(reply_synopsis)
    @success = true
  end

  private

  def reply_synopsis
    <<~MES.chomp
      【#{@novel.title}】

      #{synopsis}
    MES
  end

  def synopsis
    Narou.fetch_synopsis(@novel.ncode)[1]
  end
end
