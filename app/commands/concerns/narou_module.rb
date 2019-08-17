module NarouModule
  extend ActiveSupport::Concern
  included do
    # 小説のURLを作成する
    #
    # @params [ncode] Ncode
    #         [episode_id] エピソードID
    #         [open_browser] boolean ブラウザで開くか?
    #
    # @return [url] 小説のURL
    def narou_url(ncode, episode_id = nil, open_browser = false)
      url = "#{Constants::NAROU_NOVEL_URL}#{ncode}/"

      url += "#{episode_id}/" if episode_id

      url += "#{Constants::QUERY_DEFAULT_BROWSER}" if open_browser

      url
    end

    # 作者マイページのURLを作成する
    #
    # @params [writer_id] 作者ID
    #         [open_browser] boolean ブラウザで開くか?
    #
    # @return [url] 作者マイページのURL
    def writer_mypage_url(writer_id, open_browser = false)
      url = "#{Constants::NAROU_MYPAGE_URL}#{writer_id}/"

      url += "#{Constants::QUERY_DEFAULT_BROWSER}" if open_browser

      url
    end
  end
end
