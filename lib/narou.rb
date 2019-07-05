require 'nokogiri'
require 'json'
require 'uri'
require 'net/http'

module Narou
  class << self

    def narou_url(novel)
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
  end
end
