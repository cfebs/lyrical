require_relative '../spec_helper'

describe "the lyric and youtube system" do

  it "should fetch some youtube videos for gorillaz lyrics" do

    lyric = "it's a casio on a plastic beach"
    @links = LinkFetcher.new(lyric).get_links

    expect(@links.size).to be 2
    @links.first[:title].downcase.should include 'gorillaz'
    @links.last[:title].downcase.should include 'gorillaz'

  end

end
