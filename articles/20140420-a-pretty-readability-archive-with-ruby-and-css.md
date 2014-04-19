title: A pretty readability archive with ruby, sinatra and css transitions
post_id: 5
slug: a-pretty-readability-archive-with-ruby-and-css

#!!==========================================================

I've always found it interesting to see what other people read. Not just the things that they share on twitter, but the articles they read on a daily basis. I was thinking about that yesterday when I decided it might be nice to display my [readability](https://www.readability.com) archive on this blog. A few hours later, and you can see my archived readability articles [here](http://danny.is/writing). Here's what it looks like: 

{{image: 1}}

I started out by trying to pull down and parse an RSS feed but after discovering it's not that easy, I settled on using the [readability API](https://www.readability.com/developers/api) to get at my data.

The API offers two ways to authenticate, OAuth and XAuth. Although OAuth is generally considered the best option, it's not in this case; we want to authenticate using a username and password stored in our application rather than a callback.

Here's how to get it up and running with ruby...

I tend to store passwords and keys in ruby environment variables. I can add them to heroku with `heroku config:add MY_ENV="thing"`, and load them locally by requiring a `development-envs.rb` file in which they're set. Obviously this is ignored by git so I don't present them to the whole world on github. Here's my `development-envs.rb` file:

````ruby
ENV['BASE_DOMAIN'] = "danny.is"
ENV['READABILITY_KEY'] = "XXX"
ENV['READABILITY_SECRET'] = "XXX"
ENV['ARTICLE_PAGE_LIMIT'] = "3"
ENV['READABILITY_PASSWORD'] = "XXX"

# Add these to heroku for production with these commands:
# 
# heroku config:add BASE_DOMAIN="danny.is"
# heroku config:add READABILITY_KEY="XXX"
# heroku config:add READABILITY_SECRET="XXX"
# heroku config:add ARTICLE_PAGE_LIMIT=3
# heroku config:add READABILITY_PASSWORD="XXX"
````

You can see that we need to add our readability key, secret and password. We then need to add the [readit](https://github.com/29decibel/readit) gem to our Gemfile, require it, and set up some config:

````ruby
  configure do
    Readit::Config.consumer_key = ENV['READABILITY_KEY']
    Readit::Config.consumer_secret = ENV['READABILITY_SECRET']
    Readit::Config.parser_token = ENV['READABILITY_PARSER_TOKEN']
  end
````

I had to do a little fiddling to get XAuth working as there's very little documentation for Readit. Here's how we can do it:

````ruby
get '/reading' do

  # Set up a Consumer
  @consumer = OAuth::Consumer.new(ENV['READABILITY_KEY'], ENV['READABILITY_SECRET'],
                                  :site=>"https://www.readability.com/",
                                  :access_token_path => "/api/rest/v1/oauth/access_token/")

# Get an access token
  @access_token = @consumer.get_access_token(nil, {}, {:x_auth_mode => 'client_auth',
                                                       :x_auth_username => ENV['READABILITY_KEY'],
                                                       :x_auth_password => ENV['READABILITY_PASSWORD'] })

  # Instansiate a Readit API connection
  @api = Readit::API.new @access_token.token, @access_token.secret
````

And there it is! We've now got access to our readability bookmarks through some nice methods on `@api`. Since we want to get the bookmarks that we've archived, lets add a call to get them and render a view, which we'll call `:reading`...

````ruby
  @bookmarks, @meta = @api.bookmarks(archive: 1, per_page: 50, include_meta: true)

  erb :reading, layout: :layout_dark
end
````

Notice that we've passed in a few options - the `archive: 1` tells readit to fetch bookmarks from the archive, the `:include_meta` dumps metadata (like total number of bookmarks) into the `@meta` variable and the `:per_page` tells readit to get the last 50 bookmarks. I'd like to get 100 or so, but the maximum is 50 per 'page'.

In our reading.erb, we can set up a simple HTML structure:

````html
<div class="readability">
<% @bookmarks.each do |bookmark| %>
  <% unless bookmark.article.title.match(/^https?:\/\//) %>
    <div class="container">
      <div class="card">
        <figure class="front" style="background-image: url('<%= bookmark.article.lead_image_url %>')">
          <a href="<%= bookmark.article.url %>">
            <%= bookmark.article.title %>
          </a>
        </figure>
        <figure class="back">
          <a href="<%= bookmark.article.url %>">
            <%= bookmark.article.excerpt %>
          </a>
        </figure>
      </div>
    </div>
  <% end %>
<% end %>
</div>
````

There's nothing clever here, except that we're filtering out any articles that have URLs for titles, since they'll look awful when displayed. Note how I'm setting a background image on the figure with an inline style.

Now all we need to do is make it look pretty. Here's the CSS:

````scss
.readability {
  margin: 0 auto;
}

.readability .container {
  float: left;
  margin: 0;
  padding: 0;
  width: 200px;
  height: 200px;
  perspective: 1000;
  -webkit-perspective: 1000;
  -moz-perspective: 1000;
  overflow: hidden;
}

.readability .container:hover .card, .readability .container.hover .card {
  transform: rotateY(180deg);
  -webkit-transform: rotateY(180deg);
  -moz-transform: rotateY(180deg);
}

.readability .card {
  position: relative;
  transition: 0.6s;
  transform-style: preserve-3d;
  -moz-transform-style: preserve-3d;
  -webkit-transform-style: preserve-3d;

  width: 100%;
  height: 100%;
}

.readability figure {
  position: absolute;
  margin: 0;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  backface-visibility: hidden;
  -moz-backface-visibility: hidden;
  -webkit-backface-visibility: hidden;
  background-position: center;
  background-size: cover;
}

.readability .front {
  z-index: 2;
}

.readability .back {
  transform: rotateY(180deg);
  -webkit-transform: rotateY(180deg);
  -moz-transform: rotateY(180deg);
}

.readability .front a {
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  font-family: $sans-font;
  font-weight: bold;
  color: white;
  padding: 1em;
}

.readability .container:nth-child(n+1) .front a  {background: rgba(30,0,0,0.6); color: rgba(255,255,255,0.8)}
.readability .container:nth-child(2n+2) .front a {background: rgba(0,30,0,0.6); color: rgba(255,255,255,0.8)}
.readability .container:nth-child(3n+3) .front a {background: rgba(0,0,30,0.6); color: rgba(255,255,255,0.8)}
.readability .container:nth-child(4n+4) .front a {background: rgba(0,30,30,0.6); color: rgba(255,255,255,0.8)}

.readability .back a {
  position: absolute;
  background: rgba(0,0,0,0.8);
  top: 0; left: 0; right: 0; bottom: 0;
  font-family: $serif-font;
  color: white;
  font-size: .6em;
  padding: 1em;
}
````

And that's all there is to it!

## Future Improvements

There are a few things I could do to improve this:

- Use AJAX and readit to call more than one page of results and incorporate infinite scrolling.
- Make the grid fluid and responsive rather than fixed width. It looks hideous on small screens.
