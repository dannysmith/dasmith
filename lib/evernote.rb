module DannyIs
  module Evernote
    require 'oauth'
    require 'evernote_oauth'

    def self.notes(notebook, params = {})
      search_filter = "notebook:\"#{notebook}\""

      client = ::EvernoteOAuth::Client.new(
        token: ENV['EVERNOTE_DEV_TOKEN'],
        sandbox: false
      )
      note_store = client.note_store

      # Create Filters
      ev_filter = ::Evernote::EDAM::NoteStore::NoteFilter.new
      ev_filter.words = search_filter

      # Get Notes
      notes_list = note_store.findNotes(ev_filter, 0, 1000)

      notes = []

      notes_list.notes.each do |note|
        notes << Note.new(note.title, note.attributes.sourceURL, note_store.getNoteContent(note.guid))
      end
      return notes.reverse
    end

    class Note
      attr_reader :title, :url, :content
      def initialize(title, url, content)
        @title = title; @url = url; @content = content
      end
    end
  end
end
