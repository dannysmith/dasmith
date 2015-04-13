title: Scaled Agile Frameworks
post_id: 15
slug: scaled-agile-framework

#!!==========================================================

I was asked a question last week: ***Wouldn’t you say that large-scale agile frameworks like SAFe are just an exercise in keeping old-fashioned businesspeople busy, and making them feel more comfortable?***

Here’s my answer. Bear with me for a minute.

Lets imagine a company for a moment. They’re a smallish company of about 200 employees, and their technical teams make up just over half of that. They produce a number of online SaaS tools to help other businesses--- perhaps a suite of CRM, marketing, project management and sales software. They hire only the best team members and use a modern technology stack. Their apps are built in Rails or Node and are deployed to production almost daily via a hosted CI tool.

They’ve outsourced all their infrastructure to other companies. They use [GitHub](http://github.com) to collaborate, [Heroku](http://heroku.com) to handle their servers, S3 for static storage and [Fastly](http://www.fastly.com) as a CDN. Their app’s emails are handled by [SendGrid](https://sendgrid.com); and a combination of [New Relic](http://newrelic.com), [Airbreak](https://airbrake.io) and [Segment.io](https://segment.com) handles their errors and metrics. Their data lives on Heroku and [Compose](https://www.compose.io). They use [Zendesk](http://zendesk.com) and [Intercom.io](http://intercom.io) for customer engagement and support---even their internal communication is handled by [Slack](https://slack.com) and [Google Apps](https://www.google.com/work/apps/business/). Their work is managed using a combination of [waffle.io](https://waffle.io) and [Trello](http://trello.com), and many of these tools are integrated with one another.

Their teams focus on quality and use a lot of best practices: TDD, pairing, code reviews etc. They strictly adhere to style guides and always build their apps in a way that makes the architecture as flexible as possible.

Although there are twelve separate development teams, some use an iterative approach and some using Kanban. Their product owners and senior developers get together every two weeks to share ideas---the product owners, in particular, spend a lot of time together.

From a customer’s perspective the software is one big integrated suite, but from the teams' perspective is made up of many decoupled services. Each team usually works on a single product or set of services. These services communicate over predictable and meticulously-documented APIs and, where functionality or data is common, it’s handled by a separate service. Indeed, all these services authenticate with one-another using the InternalAuthenticationService.The API documentation, system integration tests and most of the core services are the only responsibility of one of the development teams---it’s their product.

Each team has a product owner and a number of developers. Most of the teams also have a hybrid UX/UI Designer and a Business Analyst/Tester hybrid too.

Outside of the delivery teams they have a couple of DevOps guys who manage all the hosted tools mentioned above, but they spend most of their time pairing with delivery teams to improve their automation processes. This is getting more important now that the teams are [validating their product decisions through split tests](http://danny.is/writing/delivering-business-kanban-and-validated-learning-150314). There are also a couple of Agile Coaches and Data Analysts who tend to join teams as and when their expertise is required.

The company's engineering and business practices are all recorded in a comprehensive [playbook](http://playbook.thoughtbot.com), which anyone can contribute to via pull request---subject to the usual code review process, of course.

The COO used to be a developer, and tries to join each team when he can, pairing with their developers. The rest of the leadership team is heavily involved in sales, but they all speak daily so they stay on the same page. There is a bi-weekly meeting with all the product owners and the COO, which is normally attended by at least a couple of the other guys on the leadership team. There are also regular demos, where the teams show off their work to the rest of the company.

The leadership team value transparency, and have a clear vision of the firm they want to build. They’re also incredibly passionate about their products, something which filters down to their staff. They understand the term "servant leader".

Unlike the delivery teams, they view the product suite as a whole, and have a road-map for their business. Through regular conversation with the product owners, they identify new features and projects to work on, as well as new experiments to run. All of these projects go into a prioritised *Company Backlog*---they’re usually pretty big. Most of these get picked up by product owners who break them into user stories and add them to product backlogs.

This is all facilitated by a big-picture Kanban board that shows the leadership team where everything’s at, and a WIP limit is be used to throttle the amount of work and direct teams towards any bottlenecks in this big-picture flow. It’s a fairly simple system.

...

Does this company need a complex framework to scale agile? **Absolutely not**. They have a simple way of facilitating the flow of business value from top to bottom, and coordinating work. Could this company scale? They'd have some work to maintainin their culture, but their process could certainly scale. It might need the introduction of another management layer, but the process is fundamentally sound.

How many companies are at this stage, though? How many companies have eliminated onerous or ineffective processes and imporoved collaboration to the point where a suitable system can form organnically? Most importantly, how many companies have the culture of excellence and **trust** that is required to support this? Without the right culture, an effective system is unlikeley to grow from self-organizing teams.

{{image: 2}}

If we can't grow our own system, we need to buy one off-the-shelf. That’s why we need scaled agile frameworks like SAFe.

# What is SAFe?

Much has been written about the Scaled Agile Framework (for Enterprise). Ken Schwaber is [clearly not a fan](https://kenschwaber.wordpress.com/2013/08/06/unsafe-at-any-speed/) and while Ron Jeffries has a [slightly more balanced](http://ronjeffries.com/xprog/articles/safe-good-but-not-good-enough/) view, Neil Killick describes it as a [horrible, pure money-making bastardisation and Frankenstein of Scrum, Agile and Waterfall](http://neilkillick.com/2012/03/21/the-horror-of-the-scaled-agile-framework/). I'm not sure that's fair.

At it’s core, SAFe recommends a bunch of very sensible stuff. It recognises the importance of actual leadership, mandates high code quality and introduces three layers: Portfolio, Programme and Team. Each layer has a more granular backlog, facilitating the flow of value from business goals to user story. It recommends analysing the Cost of Delay, applying WIP limits in the top level board, and has a general focus on Lean thinking. Interestingly, SAFe suggests starting a transformation at programme level rather than at the top or team level. The value of change management is usually far higher in this middle layer.

I have two major criticisms.

### Criticism One

This picture:

{{image: 1}}

It is the sort of diagram we're used to seeing on [leaked NSA Slides](http://www.slideshare.net/EmilandDC/dear-nsa-let-me-take-care-ou). It's *horrible*.

### Criticism Two
For an 'Agile' framework, SAFe seems to have a strong emphasis on centralised control, and much thought has been put into the management of process dependancies. These both smell of [Taylorism](http://en.wikipedia.org/wiki/Frederick_Winslow_Taylor) and are directly opposed to the agile notions of self-organising, independent teams.

TODO

# SAFe as a Gateway Drug

If systems like SAFe, LeSS and DAD are seen as the end result of an agile transformation, then we’ve missed the point. These frameworks exist to allow an organisation to transition from one state to another. From a monolithic  behemoth with complex inter-dependant systems and processes and a multitude of internal cultures, to a streamlined collection of independent teams, who’s separate cultures and work are aligned with the business vision.

It's interesting to note that many respondants to the State of Agile survey conducted in 2014 cited consistent process as the factor that helped them scale agile.

{{image: 3}}

Perhaps this is because...

# To Conclude

[Domonic Maximini](http://scrumorakel.de/blog/index.php?/archives/45-A-critical-view-on-SAFe.html)'s *a critical view on SAFe* does a good job of summing up:

<blockquote>It all can be summed up the following way:
<ul><li><span>SAFe believes that the world is good as it is and the existing companies, processes and structures created that world. So the status quo has to be accommodated.</span></li>
    <li><span>Agile believes that the world is not a good place (at least for people working in software development) and should be improved. The status quo – especially the tayloristic thinking - has to be changed.</span></li></ul>
<footer>Domonic Maximini</footer>
</blockquote>

In any case, SAFe has got to be better than it’s [major competitor](http://www.lafable.com).
