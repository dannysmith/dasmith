title: Writing Testable Code
article_id: 7
slug: writing-testable-code

#!!==========================================================

A little while ago, I was employed to write a suite of automated Acceptance Tests in [Cucumber](http://cukes.info) and [Watir](http://watir.com). Prior to this, I’d mainly used Cucumber and RSpec to write tests for ruby applications, and so had access to the application at runtime. With this project, however, I was testing an application that ran on PHP. In other words, the test framework was wholly independent to the production application. This presented certain difficulties, as *all* interaction with the application had to be done in one of three ways:

1. UI Automation with Watir.
2. API access
3. Direct manipulation of the Database.

Unfortunately, because the application was so complex, manipulating the database wasn’t really an option except in the most trivial of situations, and the application’s API was rather lacking in functionality (as well as being SOAP - urggh).

It seems that this sort of project – using Ruby/Cucumber/Watir to test Java/PHP/.NET/whatever applications – is becoming more and more common in the corporate IT world. Leaving aside the fact that cucumber isn’t really intended to be a testing/QA tool, I though’t I’d share some tips for *developers* on how to make the life of your *Developer in Test* a little easier. This assumes that they’re using Selenium Webdriver, Watir or Capybara or some other automated framework to interact with the app’s UI.
 

### 1. Write Semantic HTML
This should be a no-brainer, but I’m constantly amazed at how poorly structured the HTML found in large-scale web applications is. Needless to say, a logically structured DOM that makes use of semantic HTML5 is a lot easier to navigate with a tool like Watir. Try to remove unnececarry elements and use the most semantically sensible element for the task.


### 2. Use a lot of classes
Although heavy use of *presentational classes* was frowned upon a few years back, it’s now very much in vogue thanks to the idea of [atomic design](http://bradfrostweb.com/blog/post/atomic-web-design/) and CSS frameworks like SMACSS, OOCSS, Foundation and Bootstrap. From an automation point of view, it’s far easier to hook onto an element that has a class than to select elements directly. Given this HTML:

````html
<div class="prod-list">
  <… a lot of wrapping tags…>
  <ol>
    <li>
      <a href="/dosomething">
        <h2>My Product</h2>
        <p>My Product Description</p>
      </a>
    </li>
  </ol>
  <… a lot of closing tags…>
</div>
````
It’s far easier (and more reliable) to hook into the *h2* if it’s got a class like `prod-list-product-name` on it. Compare:

````ruby
@browser.div(class: 'prod-list').a.lot.of.wrapping.tags.li.first.h2
````

to

````ruby
@browser.h2(class: 'prod-list-product-name')
````

This is a trivial example, so the benefit here is minimal, but in a more complicated case, the second one is much less brittle and won’t break if the structure of the document is changed. This is particularly true where we need to traverse back up the DOM using the `parent()`  method. Watir is nowhere near as powerful as jQuery or JavaScript's `querySelector` in it’s ability to traverse the DOM and it doesn't currently support jQuery-style CSS selectors.

I’m not saying we should throw classes onto every element, but where an additional class would help to modularise CSS or add to the elements’ semantics, it will undoubtably help with writing UI tests too.

If you have a good *Developer in Test* on your team, he'll understand the web and semantics. If he asks you to add a class, then it's because he feels that's the cleanest way to solve his problem. Trust him.


### 3. Use IDs where it’s semantically sensible
Good tests should set up and tear down their own test data. To use the above example code, if I've just programatically created a new test product then I’m going to know some stuff about it. I might know the title and description, but I’ll also know it’s unique identifier. That might be an ID, slug or SKU, for example.

Let’s say I want to check that the product is displayed in our list. I *could* search for the product by title:

````ruby
@browser.div(class: 'prod-list').a.lot.of.wrapping.tags.li.h2(text: '<whatever>')
````

But what if I’ve just created a whole bunch of products that have the same title? Or if there’s some old data that wasn’t cleaned up properly, and there is more than one product with the same title?

It’s far easier for me to look for the product by it's unique identifier, so why not add that as an ID to the element:

````html
<li id="product6254">
  <a href="/dosomething">
    <h2>My Product</h2>
    <p>My Product Description</p>
  </a>
</li>
````

````ruby
@my_product = the_last_product_i_created
@browser.li(id: @my_product.sku)
````

Of course, you might have more than one list of products on the page, in which case you’d need to use classes instead. We could do this:

````html
<li class="sku-product6254">
  <a href="/dosomething">
    <h2>My Product</h2>
    <p>My Product Description</p>
  </a>
</li>
````
````ruby
@my_product = the_last_product_i_created
@browser.div(class: 'prod-list').li(class: "sku-#{@my_product.sku}")
````

In my eyes, adding classes or IDs like this improves semantics too, as we’re *adding some meaning* to the list item.

### 4. Keep markup as similar as possible, if it represents the same data
Let’s say we have two views for our product data. One is a grid and the other  is a list. They all hold the same data, but the layout is slightly different. We could choose to represent them with different HTML:

````
<!-- Grid -->
<ol classs="product-grid">
  <li>
    <a href="#">
      <h2>Produuct Title</h2>
      <img src="#" />
      <p>Product Description</p>
    </a>
  </li>
</ol>
<!-- List -->
<ul classs="product-list">
  <li>
    <img src="#" />
    <h2><a href="#">Produuct Title</a></h2>
    <p>Product Description</p>
  </li>
</ul>
````

There's nothing wrong with this, but as the tests for these two views are likeley to be very similar (but not the same), it would be nice to reuse the test code. This is a pain if the HTML structure is different.

Ask yourself the question? Why use a *ul* for one and an *ol* for another? Does it add meaning? Why wrap the whole item in a link in one case, and just the title in another? Does this add a real benefit?

Both elements could easily be represented with the same HTML, with only the class name of `product-grid` or `product-list` changing. This would allow for [DRYer](http://en.wikipedia.org/wiki/Don't_repeat_yourself) test code.

Although in this particular case the benefit isn't huge, accross a large application with a large test suite these sort of savings can massivley reduce the cost associated with maintaining a working test suite.


### 5. If you have multiple elements in the DOM that are hidden by JS, give the visible one a class like ‘visible’.
One of the most common cause of flaky UI tests is using Watir and the like to hover on things. The functionality is notoriously unreliable, and is even more prone to errors when the hover event fires an AJAX call to load some data into the DOM. It's also a pain to differenciate between hidden and visible elements when selecting them.

Using the example above, we might have both the List and Grid HTML in the DOM, and use JavaScript to hide and show the two lists when a user toggles a 'view' button. If, in addition to toggling the `display` property, you add a `.visible` or `.hidden` class to the lists, I can easily:

1. Check if the list is displayed without knowing what's in it and;
2. Select only the visible list (`@browser.div(class: 'product-grid visible')`)

By adding a `.visible` class to dropdowns and popups which have been displayed through a hover event, it's also easier to check that they are visible before interacting with them. Even better, include a way to make the element visible through a simple JS call, or by adding the `.visible` class from the test code. This avoids the need to hover at all.

aside> In this age of mobile devices, it's not usually a good idea to rely soley on hover events to display dropdown menus and the like. What happens on a touch device where a user *can't* hover? Or when a user is browsing with a screen reader? Of course, if all of your hover elements also respond to click/tap events, it makes things a lot easier for UI automation.


### 6. Avoid complex DOM structures and clever JS that changes the DOM in complicated and unintuitive ways
This should be a no-brainer anyway. With the exception of single-page web apps and things like [turbolinks](https://github.com/rails/turbolinks), any JS that radically alters the DOM, particularly in unexpected ways, isn't a good idea. 

If you're going to use JS to replace half the DOM with new HTML, then for the love of god, update the URL and replace the entire contents of some container rather than random bits all over the place. And make sure it's documented, or obvious from the source.


### 7. Make your settings changeable through an API
Most web applications have settings: both application-level flags and user-level options. If the application under test is on a different stack and it's not possible for a test suite to set and alter these at runtime, then make it possible to change them some other way:

1. You could create a private web API that accepts JSON objects representing the app's settings.
2. You could store them in a clean database table and allow access to that
3. You could write a non-web API to interface with Ruby or whatever.

My money's on the first one being the best option, as it'll also be of use to manual testers and, possibly, automated deploys or updates.

For the love of god though, don't make test code automate it's way through a back-end admin panel to change settings. That's time-expensive, brittle and completely insane.


### 8. Make the data in your app available through a sensible API
Let's look at the example we've been using. Clearley, our app contains products. The test code *should* be able to create, manipulate and destroy products as it executes. There are a whole host of methods we could use to do this, but the simplest is to expose your data through a RESTful API which allows CRUD operations.

If you stick to the accepted conventions, it's entirely possible that whoever writes your tests could use an ORM like [Her](https://github.com/remiprev/her) to map that API into ruby objects without much effort at all. If you don't stick to conventions, or simply don't build an API, your *Developer in Test* is going to have to write his own library to wrap the test data up in ruby objects or in the worst case, won't be able to setup data at all.

Of course, there's an added bonus to having a REST API. Much like exposing your settings over one, allowing data manipulation through it opens up a whole host of possibilities for quickly developing admin tools and services, as well as speeding up the development of mobile apps and third-party integrations.


### 9. Split your code into separate modules which speak to one another through APIs.
Following on from the last point, if it's at all possible you should split your application down into small services which speak to one another over a standard API. This has benefits far beyond testing, but the key ones from a *Developer in Test*'s point of view are:

1. Unit Tests are likeley to become easier to manage
2. System Integration Tests are easier to handle
3. It's easier to mock and stub in any sort of integration tests.
4. Acceptance Tests can more easily assume that the lowe-level components of the system actually work as intended.

This last one's important here. If I know that the internal unit tests and external API tests for *Web Service X* are all passing, I *know* that it will always return the correct response to my Acceptance Tests. It allows acceptance tests to do their job – tesing that the app meets the business acceptance criteria.

In a more complex system with millions of interdependant variables in play, it's not always possible to know whether an acceptance test is failing because of some underlying bug or conflict that isn't covered by lower-level tests.

Of course, this is more about architecture than testing, so perhaps I should just say *"Think about your app's architecture, and prefer small self-contained modules over monolithic systems."*

aside> For the love of god, document your modules and APIs properly, including code examples. You could consider using some sort of documentation generator that means it's always up-to-date.

### 10. Make sure your code is structured, and unit tests cover everything.
This is a no-brainer. If a UI Acceptance Test fails and there isn't complete unit test coverage, it can be a nightmare to identify the source of the failure.

If your team can't yet write good unit tests, preferably using TDD, then don't waste time and money on automated functional or acceptance tests.

### 11. *Talk* to the people writing your acceptance tests.
Leaving aside the fact that Cucumber is [intended as a language to facilitate communication](https://cucumber.pro/blog/2014/03/03/the-worlds-most-misunderstood-collaboration-tool.html), and that features should be written by [Three Amigos&#8482;](http://www.scrumalliance.org/community/articles/2013/2013-april/introducing-the-three-amigos), you – the developers – should talk to your developers in test.

<blockquote><p>You have a team of six developers writing a complex application. I have one developer writing a <strong>seperate</strong> application that tests yours. Your application has no way for my developer to hook into it, and unit and functional tests can't be relied upon. That means that the test application will have to mimic many of the functions in yours. What makes you think the test system will be quick or simple to build?</p></blockquote>

Until a few years ago, the people doing testing (the corporate world calls them "QAs") were manual testers, perhaps with a little knowledge of programming or Selenium scripting. These days they're called *Developers in Test* or *Automation Engineers*. Note the terms: "Developer" and "Engeneer".

I've yet to meet a *good* developer in test who couldn't also work happily on production code, so if you're in one of those shops that still sees DiTs as "QA people that aren't proper developers" then please, please, please, get over it. In many cases, they'll know as much about application architecture as you do.

In other words – **trust** the people writing your tests or, even better, write them yourself.
