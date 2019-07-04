require 'nokogiri'
require 'json'
require 'uri'
require 'net/http'

module Narou
  class << self
    NAROU_API_URL = 'https://api.syosetu.com/novelapi/api/'
    NAROU_NOVEL_URL = 'https://ncode.syosetu.com/'
    SEP = '/'

    def narou_url(novel)
      NAROU_NOVEL_URL + novel.ncode + SEP + novel.last_episode_id.to_s + SEP
    end

    def next_episode_id(novel_last_episode_id)
      novel_last_episode_id.next
    end

    def fetch_episode(ncode)
      uri = URI.parse(NAROU_API_URL + "?/lim=1&of=t-ga&ncode=#{ncode}&out=json")
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)
      _, info = result
      [
        info["title"],
        info["general_all_no"]
      ]
    end
  end
end
