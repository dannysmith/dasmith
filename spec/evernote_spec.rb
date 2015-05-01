require 'spec_helper'

describe DannyIs::Evernote do
  it "loads notes from a particular notebook", integration_test: true do
    notes = DannyIs::Evernote.notes('danny.is Links')

    expect(notes).to be_an Array
    expect(notes.first).to be_an DannyIs::Evernote::Note
    expect(notes.first.title).not_to be nil
    expect(notes.first.content).not_to be nil
    expect(notes.first.url).to match /.+:\/\/.+/
  end

  it "correctly creates note objects" do
    note = DannyIs::Evernote::Note.new 'This is the note', 'http://google.com', '<p>Here is content</p>'

    expect(note.title).to eq 'This is the note'
    expect(note.url).to eq 'http://google.com'
    expect(note.content).to eq '<p>Here is content</p>'
  end
end
