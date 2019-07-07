class NovelAdd < Command
  def initialize(user_info, request_info)
    super
  end

  def call
    ncode = @request_info.user_send_text.match(Constants::REG_NCODE).to_s
    add_novel(ncode)
  end

  private

  def add_novel(ncode)
    novel = Novel.build_by_ncode(ncode)

    if novel&.save
      @success = true
      @message = UserCheckNovel.link_user_to_novel(user.id, novel.id) ? already_registered(novel) : created(novel)
    else
      @message = unprocessable_entity
    end
  end

  # Messege START ------------------------------------------- #
  def created(novel)
    Constants.reply_success_novel_add(novel.title)
  end

  def already_registered(novel)
    Constants.reply_already_registered_novel(novel.title)
  end

  def unprocessable_entity
    Constants::REPLY_MESSAGE_ADD_FAILURE
  end
  # Messege END --------------------------------------------- #
end