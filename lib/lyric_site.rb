require 'nokogiri'
require 'net/http'
require 'uri'
require 'json'
require 'open-uri'

# A lyric site
class LyricSite
  def initialize()
    @query_uri = nil
  end

  # The main work function
  def get_links(query)
    html = open(self.build_uri(query))
    doc = Nokogiri.HTML(html)
    return self.parse_doc(doc)
  end

  # returns the links
  def parse_doc()
    return []
  end

  def build_uri(query)
    str = URI.escape(query)
    return "#{@query_uri}#{str}"
  end

  # remove common lyric site names
  def remove_lyrics(str)
    #return str
    str = str.gsub(/\s*youtube\s*/i, '')
    #eLyrics.net
    str = str.gsub(/\s*elyrics\.net/i, '')
    # Lyric Meanings
    str = str.gsub(/\s*lyric[s]?\s*meaning[s]?/i, '')
    # lyric freak.com
    str = str.gsub(/\s*freak\.com/i, '')
    # song freak.com
    str = str.gsub(/song\s*freak\.com/i, '')
    # metro lyrics
    str = str.gsub(/metro\s*lyric[s]?/i, '')
    str = str.gsub(/lyric[s]/i, '')
  end

  # Cleans text
  def clean_text(str)
    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :universal_newline => true       # Always break lines with \n
    }
    str.encode!(Encoding.find('ASCII'), encoding_options)
  end
end

class Google < LyricSite

  def initialize
    @query_uri = "http://www.google.com/search?q="
  end

  def parse_doc(doc)
    doc.css('style, script, img, objecft, embed, iframe, canvas').remove
    search = doc.css('#search')[0]
    # nice end for a lite search
    # return search.to_s
    links = []
    search.css('li.g h3 a').each do |link|
      text = self.clean_text(link.text)
      links << {
        :href => link.attr('href'),
        :text => self.remove_lyrics(text).downcase.strip}
    end

    return links[0, 4]
  end

  # Build a Google uri
  # Add lyrics to the search
  def build_uri(query)
    if !(/lyric[s]/i.match(query))
      query = "#{query} lyrics"
    end

    str = URI.escape(query)
    return "#{@query_uri}#{str}"
  end
end

# Newer youtube results, uses the li data attributes to get the video ids
class Youtube < LyricSite
  def initialize
    @query_uri = "http://www.youtube.com/results?search_query="
  end

  def parse_doc(doc)
    search = doc.css('ol#search-results')[0]

    return [] if !search

    links = []
    search.css('li.yt-lockup-video').each do |link|
      video_id = self.clean_text(link.attr('data-context-item-id'))
      title = self.clean_text(link.attr('data-context-item-title'))
      links << {
        :id => video_id,
        :title => title
      }
    end

    return links
  end
end

# No longer works
class YoutubeOld < LyricSite
  def initialize
    @query_uri = "http://www.youtube.com/results?search_query="
  end

  def parse_doc(doc)
    search = doc.css('#results-main-content')[0]

    return [] if !search

    links = []
    search.css('li.result-item-video h3 a').each do |link|
      text = self.clean_text(link.text)
      links << {
        :href => link.attr('href').gsub(/\/*watch\?v=/i, '')
      }
    end

    return links
  end
end
