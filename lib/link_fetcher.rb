require './lib/lyric_site'

class LinkFetcher

  def initialize query
    @query = query
  end

  def get_links
    youtube_links = fetch_links
    build_links youtube_links
  end


  #
  def fetch_links
    links = get_google_links
    puts links

    youtube_links = []

    links.each do |link|
      link_text = link[:text]
      youtube_links << get_youtube_links(link_text)[0]
    end

    youtube_links
  end


  # Unique map of links
  def build_links links
    links.uniq! { |link| link[:id] }
    links.each do |link|
      link[:title] = truncate_title(link[:title])
    end

    links
  end

  def get_youtube_links query
    Youtube.new.get_links query
  end

  # Opens the google search page and gets the h3 links
  def get_google_links
    Google.new.get_links @query
  end

  def truncate_title(t, l=45)
    if t.length > l
      t[0, l] + ' ...'
    else
      t
    end
  end

end
