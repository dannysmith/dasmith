require 'spec_helper'

describe DannyIs::ReadingList do
  context "Over the API" do
    it "loads a readability reading list", integration_test: true do
      bookmarks = DannyIs::ReadingList.load(:readability)
      expect(bookmarks).to be_an Array
      expect(bookmarks.first).to be_a DannyIs::ReadingList::Item
    end

    # it "loads a pocket reading list", integration_test: true do
    #   bookmarks = DannyIs::ReadingList.load(:pocket)
    # end

    it "combines all reading lists", integration_test: true do
      bookmarks = DannyIs::ReadingList.load
    end
  end

  it "correctly creates item objects" do
    note = DannyIs::ReadingList::Item.new(
      title: 'This is the bookmark',
      image: 'http://image.com/img.png',
      url: 'http://linky.com',
      excerpt: '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Aliquid, inventore sed',
      service: :readability,
      date: DateTime.parse('2014-01-01'),
      word_count: 2845
    )
    expect(note.title).to eq 'This is the bookmark'
    expect(note.url).to eq 'http://linky.com'
    expect(note.image).to eq 'http://image.com/img.png'
    expect(note.excerpt).to eq '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Aliquid, inventore sed'
    expect(note.service).to eq :readability
    expect(note.date).to eq DateTime.parse('2014-01-01')
    expect(note.word_count).to eq 2845
  end
end
