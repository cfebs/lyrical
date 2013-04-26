require_relative '../spec_helper'

describe "the lyric and youtube system" do

  it "should fetch some youtube vieos for lyricswu tang links" do

    lyric = "it's a casio on a plastic beach"
    @links = LinkFetcher.new(lyric).get_links

    @links.length > 2
    @links.first[:title].downcase.should include 'gorillaz'
    @links.last[:title].downcase.should include 'gorillaz'

  end

end
