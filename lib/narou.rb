require 'json'
require 'uri'
require 'net/http'

module Narou
  class << self

    def narou_url(novel)
      Constants::NAROU_NOVEL_URL + novel.ncode + Constants::URL_SEP
    end

    def narou_url_with_episode_id(novel)
      Constants::NAROU_NOVEL_URL + novel.ncode + Constants::URL_SEP + novel.last_episode_id.to_s + Constants::URL_SEP
    end

    def next_episode_id(novel_last_episode_id)
      novel_last_episode_id.next
    end

    def fetch_episode(ncode)
      uri = URI.parse(Constants::NAROU_API_URL + Constants::NAROU_API_QUERY_FETCH_EPISODE + ncode)
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)
      return false if (result[0])[Constants::NAROU_API_SEARCH_RESULT_COUNT].zero?

      _, info = result
      [
        true,
        info[Constants::NAROU_API_NOVEL_TITLE],
        info[Constants::NAROU_API_NOVEL_EPISODE_COUNT],
        DateTime.parse(info[Constants::NAROU_API_POSTED_AT])
      ]
    end

    # 最大500件を引数にエピソード数を取得する
    #
    # @params ncodes Array<String> ncode=> /n\d{4}\w{1,3}/
    #
    # @return Array<Struct :ncode, :episode_count>
    #   ncode: DESC
    def fetch_next_episodes(ncodes)
      uri = URI.parse(Constants::NAROU_API_URL + Constants::NAROU_API_QUERY_FETCH_NEXT_EPISODES + ncodes.join('-'))
      json = Net::HTTP.get(uri)
      results = JSON.parse(json)

      data = Struct.new(:ncode, :episode_count)

      results
        .drop(1)
        .sort { |a, b| b['ncode'] <=> a['ncode'] }
        .each_with_object([]) do |result, arr|
          arr << data.new(
            result[Constants::NAROU_API_NCODE].downcase,
            result[Constants::NAROU_API_NOVEL_EPISODE_COUNT]
          )
      end
    end

    def fetch_writer_info_by_ncode(ncode)
      uri = URI.parse(Constants::NAROU_API_URL + Constants::NAROU_API_QUERY_FETCH_WRITER + ncode)
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)

      return false if (result[0])[Constants::NAROU_API_SEARCH_RESULT_COUNT].zero?

      _, info = result
      [
        true,
        info[Constants::NAROU_API_WRITER_ID],
        info[Constants::NAROU_API_WRITER_NAME]
      ]
    end

    # 指定した作者IDの投稿諸説を、新規投稿順で取得する。
    #
    # param [writer_id] 作者のID。String
    #   example '288399'
    #
    # return [count, result]
    #   count Integer 小説投稿数
    #   result Array<Hash>
    #
    #   example
    #     14,
    #     [{"title"=>"オーク英雄物語　～忖度列伝～", "ncode"=>"N8418FF", "writer"=>"理不尽な孫の手"}]
    #
    def fetch_writer_episodes_order_new_post(writer_id)
      uri = URI.parse(Constants::NAROU_API_URL + Constants::NAROU_API_QUERY_FETCH_WRITER_NEW_EPISODE + writer_id.to_s)
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)
      count = (result.shift)[Constants::NAROU_API_SEARCH_RESULT_COUNT]
      [count, result]
    end

    # 指定した複数の作者IDの投稿小説を、作者IDごとに新規投稿順で取得する。
    #
    # @params [Array<writers>] 作者一覧
    #
    # @return [writer_id: {count: n, ncodes: [ncode,..]},..]
    #   writer_id Integer  作者ID。 この項目ごとにグルーピングされる。
    #   count     Integer  作者ごとの小説投稿数。
    #   [ncode]   String   新規投稿小説の ncode。新規投稿順にオーダーされる。
    #
    # @example
    #   [
    #     235132: {
    #       count: 3,
    #       ncodes: {
    #         ncode: n0000aa,
    #         ncode: n0000ab,
    #         ncode: n0000ac,
    #       }
    #     },
    #     474038: {..}
    #   ]
    #
    def fetch_writers_episodes_order_new_post(writers)
      split_writer_id_arr = split_writer_id(writers)
      split_writer_id_arr.map do |arr|
        uri = URI.parse(Constants::NAROU_API_URL + Constants::NAROU_API_QUERY_FETCH_WRITER_NEW_EPISODES + arr.join('-'))
        json = Net::HTTP.get(uri)
        result = JSON.parse(json)
        result.shift
        ncodes_build = ->(ncodes) { ncodes.map { |ncode| { ncode: ncode.downcase } } }
        ret = result.group_by { |ret| ret['userid'] }
          .map do |writer_id, val|
            {
              writer_id => {
                count: val.count,
                ncodes: ncodes_build.call(val.map { |n, _| n['ncode'] })
              }
            }
          end
        return ret.flatten
      end
    end

    # あらすじを取得する
    def fetch_synopsis(ncode)
      uri = URI.parse(Constants::NAROU_API_URL + Constants::NAROU_API_QUERY_FETCH_SYNOPSIS + ncode)
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)

      return false if (result[0])[Constants::NAROU_API_SEARCH_RESULT_COUNT].zero?
      _, info = result
      [
        true,
        info[Constants::NAROU_API_STORY]
      ]
    end

    private

    # フェッチする際に取得可能件数を超えないために分割する。
    #
    # 作者毎 (writer.novel_count + 3)
    # 作者毎に配列に追加し、500を超えるようなら新たな配列に追加していく。
    #
    # @params writers 作者一覧
    #
    # @return [[id1, id2,..], [id101, id102,..]]
    #
    def split_writer_id(writers)
      # 作者ごとの更新投稿最大値目安。あくまで重みとして扱う。
      writer_posting_factor = 2
      # 一回のフェッチで取得できる小説の最大件数。
      can_fetch_novel_count = Constants::NAROU_API_QUERY_ATTRIBUTE_LIMIT_MAX
      # 配列のグループ番号を示す。１つのグループが埋まるたびにインクリメントされる
      arr_group_id = 1
      # 現在追加するグループに何件入っているか示す
      group_added_count = 0

      # [id, count]
      # [group_id, id, count]
      #   [group_id: [group_id, id, count],..]
      #   [[グループ１], [グループ２],..]
      ret = writers.map { |writer| [writer.writer_id, writer.novel_count + writer_posting_factor] }
        .tap { |writers|
          writers.map! do |id, count|
            if (count + group_added_count) > can_fetch_novel_count
              arr_group_id = arr_group_id.next
              group_added_count = 0
            end
            group_added_count = group_added_count + count
            [
              arr_group_id,
              id,
              count
            ]
          end
        }
        .group_by(&:first)
        .map { |arr| arr[1] }
        .map { |ar| ar.map { |a| a[1] } }
    end
  end
end
