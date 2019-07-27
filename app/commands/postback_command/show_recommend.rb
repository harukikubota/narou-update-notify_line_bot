require_relative '../../../lib/line_request/line_message/element/carousel_column.rb'
require_relative '../../../lib/line_request/line_message/element/carousel_element.rb'

class ShowRecommend < PostbackCommand
  def initialize(request_info)
    super
  end

  def call
    @message = create_message
    @success = true
  end

  private

  def create_message
    [
      LineMessage.build_by_single_message(message_header),
      LineMessage.build_carousel(message_contents)
    ]
  end

  def message_header
    'bot作者おすすめのなろう小説一覧です！'
  end

  def message_contents
    element = CarouselElement.new('作者のおすすめ')
    recommend_list.each_with_object(element) { |recommend, ele| ele.add_column(column(recommend)) }
  end

  def column(recommend_info)
    writer_name = "作者名／#{recommend_info.writer.name}"
    title = recommend_info.novel.title
    CarouselColumn.new(writer_name, title)
      .add_action(action_show_synopsis(recommend_info.novel.id))
      .add_action(action_show_narou_page(recommend_info.novel.ncode))
  end

  # 作者おすすめのなろう小説一覧
  def recommend_list
    Recommend.recommends_order_rank
  end

  def action_show_synopsis(novel_id)
    {
      type: 'postback',
      label: 'あらすじを表示',
      data: "action=show_synopsis&novel_id=#{novel_id}"
    }
  end

  def action_show_narou_page(ncode)
    uri = "#{Constants::NAROU_NOVEL_URL}#{ncode}/#{Constants::QUERY_DEFAULT_BROWSER}"
    {
      type: 'uri',
      label: 'なろうページに移動',
      uri: uri
    }
  end
end
