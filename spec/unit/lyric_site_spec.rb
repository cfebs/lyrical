require_relative '../spec_helper'

describe "the lyric site" do

  it "finds youtube links from search" do
    links = Youtube.new.get_links 'super fast jelly fish'
    expect(links.size).to be > 2
  end

end
