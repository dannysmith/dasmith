title: Delivering Business Value with Kanban and Validated Learning
post_id: 14
slug: delivering-business-kanban-and-validated-learning

#!!==========================================================

I've recently been reading [The Lean Startup](http://www.amazon.co.uk/The-Lean-Startup-Innovation-Successful/dp/0670921602) by Eric Ries. Considered by many to be mandatory reading for those in the startup world (and I include those running 'startups' within larger, more traditional firms in this), it's packed with insights and case studies to help companies achieve success.

One of the core ideas is that of validated learning. We all make assumptions when we're building new features, products and companies. We might assume that our new feature will increase user engagement or that a change to our homepage will increase signups, or that customers will buy our new product. Often, we just assume---or at least hope---that these assumptions are correct. Ries suggests that we use experiments to validate our assumptions, or hypotheses, with real data.

One of the problems I've been pondering recently is that of [customer feedback](/writing/feedback-loops-150126). In many agile methodologies we focus our energy on ensuring that delivery teams are working well. There is often an assumption that those responsible for providing these teams with work (product owners, for example), are providing user stories that are actually valuable to the business.

There are all sorts of strategies for helping product owners and programme managers prioritise their features and user stories to maximize business value. In his excellent book [Specification by Example](http://specificationbyexample.com), Gojko Adzic recommends that we first define business goals and use them to derive scope in the form of user stories. [Impact Mapping](http://gojko.net/effect-map/) is a tool that can help with this.

Ultimately, though, the decisions on what features to build and what impact they will have on the users and business is left in the hands of product owners. Even then, their decisions are often based on assumptions or unreliable market research.

The other problem I've been pondering is that of building a good company culture. It's often very difficult to build a culture where delivery teams truly believe in the product they're building. I've seen too many teams that are solely focused on producing high-quality product from a design/technical point of view, but give little thought to the value that their work provides to the customer and company.

It could be argued that this is not with in the remit of an agile delivery team, but I'm of the opinion that for a product to be successful, those making it should be somehow invested in its success.

# A Note on Kanban, for the Unfamiliar

[Kanban](http://en.wikipedia.org/wiki/Kanban) is an agile development methodology developed by Toyota. At a basic level, a team uses a task board with work in progress (WIP) limits assigned to each column:

{{imageraw:1}}

Because the work in the *Deploy* column is limited to 2, there can only ever be two stories in that column. Let's assume that we've had trouble deploying a couple of features. Since we can't progress those from *Deploy* to *Done*, we can't progress any of the other stories on the board into *Deploy* (because the WIP limit is 2).

The limits in the dev and deploy columns prevent team members from taking new stories from the backlog. Instead, they should apply themselves to helping clear the 'jam' in the system -- in this case, helping to deploy the two stories in the *Deploy* column. This is essentially a way of directing resources towards bottlenecks in the delivery flow.

# Delivery Teams and Deployment

Until a few years ago, it wasn't necessarily normal to have a *Deploy* column on a development team's task board. Deploying code to production was often a delicate task that required a deep knowledge of infrastructure, and was seen as the domain of Sys Admins and Ops people. That started to change with the introduction of build tools and services like [Heroku](https://www.heroku.com), and is continuing to change thanks to tools like [Docker](https://www.docker.com). It's now considered normal for teams to release into production regularly. In many cases, all that's needed to trigger a build and release is a push or merge to a production branch.

This shift in practices has let development teams to take responsibility for the process and code that handles the deployment of their apps, as well as for the app's code itself.

# Back to Culture and Business Value

Those two issues I've been pondering could be summarised as:

1. Delivery Teams often assume product owners are making the right decisions on what to build.
2. Because they may not have a say, and the product owners' decisions are often based on assumptions instead of empirical data, delivery teams are often not responsible for---or invested in---the success of the product. This can be damaging to cross-team cohesion and culture.

While discussing [Grockit](https://grockit.com)'s system of work, Ries describes a simple method that I expect would go a long way towards addressing these: Add a *Validated* column to your Kanban board and give it a limit.

What do I mean by *validated*? Grockit defined this as: "Knowing weather the story was a good idea to have been done in the first place".

We're essentially changing our definition of done to say "A story isn't done until we've proved, through actual observation, that is has real business value".

For me, that's pretty powerful stuff. In the same way that including a 'deploy' column helped teams become responsible for the deployment of their product, and to build it in such a way that deployment was as easy as possible, this should help them become responsible for testing the business value of their product.

A detailed discussion of the methods we might use to measure this value is a topic for another time, but is likely include [A/B testing](http://en.wikipedia.org/wiki/A/B_testing). If the split test proves that the feature adds value by increasing revenue (or adoption, or whatever metrics you're using to measure business success), then the story is done. If it has no effect, the we remove the feature, since it doesn't add any value to our product.

This helps us to address our first problem, since it allows a product owner to validate his assumptions about what features are likely to add value to the business. Over time this learning might well compound, and provide an archive of experiments to help inform product decisions.

It also has the effect of directly involving the delivery team in assessing impact. What if the limit on the *Validate* column is set to one? That means we can only deploy a new feature once we've validated our assumptions about the value of the previous one. If it's proving difficult to do this, then the delivery team must concentrate their work on that until its done.

Continuous Integration and build tools have caused deployment and testing code to rise in importance so that most teams view them as equal in importance to production code. I can't help but wonder if this would help teams view the code that handles split tests and experiments in the same way.

I think this simple method could have a profound impact on a lot of products, but I'm also aware that it would be difficult to adopt in organizations that are not already set up to validate learning about the stuff they ship.

What are your thoughts?
