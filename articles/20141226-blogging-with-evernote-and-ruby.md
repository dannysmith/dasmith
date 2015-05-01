title: Blogging with Evernote and Ruby
article_id: 8
slug: blogging-with-evernote-and-ruby

#!!==========================================================

For some time now, I've wanted to share interesting links, along with a comment, on this website.

This poses certain problems, though. Although this site is built on Sinatra and is therefore dynamic, it isn't backed by a database. Instead, I write articles in markdown and they're [parsed when the app spins up](/writing/new-job-new-website-131002). To publish an article I simply push to github. Unlike [Ron Jeffries](http://ronjeffries.com/articles/ipads-and-other-needs/ipads.html), this works great for me, as I always edit and publish from my laptop.

With link sharing it's a bit different. I often stumble across links while I'm travelling: that means I'm on my iPad or phone. Pushing a new version of the site to github clearly isn't an option, then.

For a while, it seemed that my best option was to either:

1. **Build a database and web backend into the site.** This would be far too clunky and time-consuming to use on mobile devices.
2. **Build a database and API into the site**, and build an iOS sharing widget to send POSTs to it. Although interesting, this would be too complex and time-consuming to build.
3. **Pull tweets with a certain hashtag from twitter.** This would work, but would limit the notes I could add significantly, which isn't ideal.

## Evernote to the Rescue

Last week, I was sat on the train from London to Eastbourne when a possible solution hit me. I use Evernote daily, through my iPad and phone, and through the OSX menuabar app. And **Evernote has an API**. I wonder if I could use that API to pull notes from a certain notebook, using the url field, title and body to store the URL, link title and note respectively. This would also partially work with notes saved from the Evernote iOS sharing widget and I could build a [workflow](https://workflow.is) to make the process entirely automatic.

Turns out this is perfectly possible. Here's how...

First off, we need a [consumer secret and token](https://dev.evernote.com/) from Evernote (click 'Get an API Key').  We'll also need to [get a developer token](https://dev.evernote.com/doc/articles/authentication.php#devtoken) and notestore URL. Although OAuth is recommended, that won't work here because we wan't to use our own evernote account rather than a user's. Armed with these credentials we can set up some environment variables in our app. Don't forget to add these to heroku's config if you're using it to deploy.

````ruby
ENV['EVERNOTE_CONSUMER_KEY'] = 'xxx'
ENV['EVERNOTE_CONSUMER_SECRET'] = 'xxx'
ENV['EVERNOTE_DEV_TOKEN'] = 'xxx'
ENV['EVERNOTE_NOTESTORE_URL'] = 'xxx'
````

We also want to add [evernote_oauth](https://github.com/evernote/evernote-oauth-ruby) to our Gemfile and `bundle install`.

Now let's create a method that, given [a filterstring](https://dev.evernote.com/doc/articles/search_grammar.php), will return an array of all the matching notes, represented as hashes:

````ruby
  def get_evernote_notes(filter)
    client = EvernoteOAuth::Client.new(
      token: ENV['EVERNOTE_DEV_TOKEN'],
      sandbox: false
    )
    note_store = client.note_store

    # Create Filter
    ev_filter = Evernote::EDAM::NoteStore::NoteFilter.new
    ev_filter.words = filter

    # Get the first 1000 Notes that match the filter
    notes_list = note_store.findNotes(ev_filter, 0, 1000)
    
    # Create an empty array to hold our notes.
    notes = []

    # For each note, add a hash containing the title, content and url
    #  to the notes array. We need to make another API call to get the
    #  note content.
    notes_list.notes.each do |note|
      notes << {
        title: note.title,
        content: note_store.getNoteContent(note.guid),
        url: note.attributes.sourceURL
      }
    end

    # Return the notes array, with the most recent ones first.
    return notes.reverse
  end
````

We can then call this method with a filter in one of our routes and use `@links` in our view:

````ruby
  get '/noting/?' do
  @links = get_evernote_notes 'notebook:"Website Links"'
  erb :links
  end
````

````html
<ul>
<% @links.each do |link| %>
<li>
  <a href="<%= link[:url] %>"><%= link[:title] %></a>
  <div class="article-list-description"><%= link[:content] %></div>
</li>
<% end %>
</ul>
````

And there it is. You can see some of the links I've shared [here](/sharing). I'm using the same method to pull some short [agile tips](/agile) from a different notebook. Here's the evernote notebook that contains my links:

{{image:1}}

## Problems with this Approach

The biggest problem with this is the fact that, on every request, the site makes a number of API requests to evernote in order to authenticate, fetch the notes and then fetch the contents of each note. This not only slows down the page load time, but could cause API rate limit issues with high traffic volume. If I just wanted to improve the perceived performance, I could render a page with a spinner of some sort, and make the API calls asynchronously with JavaScript, loading the notes as they arrive from evernote.

I suspect the best way, however, would be to have a worker poll the Evernote API [every 15 minutes](https://dev.evernote.com/doc/articles/polling_notification.php) for new notes and save them in a database, or use webhooks to populate the database every time a note is changed.



