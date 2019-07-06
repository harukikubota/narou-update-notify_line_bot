class AddNovel < Command
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
      UserCheckNovel.set_entity(user.id, novel.id)
      @message = created(novel)
      @success = true
    else
      @message = unprocessable_entity(novel)
    end
  end

  # Messege START ------------------------------------------- #
  def created(novel)
    Constants::REPLY_MESSAGE_ADD_CREATE + novel.title
  end

  def unprocessable_entity
    Constants::REPLY_MESSAGE_ADD_FAILURE
  end
  # Messege END --------------------------------------------- #
end