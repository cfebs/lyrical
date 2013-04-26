require_relative '../spec_helper'

describe "the link fetcher" do

  it "builds links correctly" do
    fetcher = LinkFetcher.new 'test'

    links = [
      {:id => 1, :title => 'foo'},
      {:id => 2, :title => 'bar'},
      {:id => 2, :title => 'bar'},
    ]

    expected = [
      {:id => 1, :title => 'foo'},
      {:id => 2, :title => 'bar'},
    ]

    finished = fetcher.build_links links
    finished.should eql expected
  end

end
