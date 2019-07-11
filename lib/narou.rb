require 'nokogiri'
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
        info[Constants::NAROU_API_NOVEL_EPISODE_COUNT]
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
  end
end
