title: Scaled Agile Frameworks
post_id: 15
slug: scaled-agile-framework

#!!==========================================================

I was asked a question last week: ***Wouldn't you say that large-scale agile frameworks like SAFe are just an exercise in keeping old-fashioned businesspeople busy, and making them feel more comfortable?***

The short answer is **yes, I do**. But that's not to say they're not valuable. Let me explain why... bear with me for a minute or two.

Lets imagine a company for a moment. They're a smallish company of about 200 employees, about half of whom are on their technical teams. They produce a number of online SaaS tools to help other businesses --- perhaps a suite of CRM, marketing, project management and sales software. They hire only the best team members and use a modern technology stack. Their apps are built in Ruby, Rails or Node and are deployed to production daily via a hosted CI tool.

They've outsourced all their infrastructure to other companies. They use [GitHub](http://github.com) to collaborate, [Heroku](http://heroku.com) to handle their servers, S3 for static storage and [Fastly](http://www.fastly.com) as a CDN. Their app emails are handled by [SendGrid](https://sendgrid.com); and a combination of [New Relic](http://newrelic.com), [Sentry](https://getsentry.com) and [Segment.io](https://segment.com) handle their errors and metrics. Their data lives on Heroku and [Compose](https://www.compose.io). They use [Zendesk](http://zendesk.com) and [Intercom.io](http://intercom.io) for customer engagement and support --- even their internal communication is handled by [Slack](https://slack.com) and [Google Apps](https://www.google.com/work/apps/business/). Their work is managed using a combination of [waffle.io](https://waffle.io) and [Trello](http://trello.com), and many of these tools are integrated with one another.

Their teams focus on quality and use a lot of best practices: TDD, pairing, code reviews etc. They have a strict system of quality control that means they have very few defects in production, and they always build their apps in a way that makes the architecture as flexible as possible.

Although there are twelve separate development teams, some use an iterative approach and some prefer Kanban. Their product owners and senior developers get together every two weeks to share ideas and plan --- the product owners, in particular, spend a lot of time together day-to-day.

From a customers perspective the software is one big integrated suite, but from the teams' perspective is made up of many decoupled services. Each team is responsible for a set of products and services, although anyone can submit pull requests for them. These services communicate over predictable and meticulously-documented APIs and, where functionality or data is common, it's handled by a separate microservice. Indeed, this plethora of services authenticate with one-another using the InternalAuthenticationService.The API documentation, system integration tests and most of the core services are the only responsibility of one of the development teams --- it’s their product.

Each team has a product owner and a number of developers. Most of the teams also have a hybrid UX/UI Designer and a Business Analyst/Tester hybrid too.

Outside of the delivery teams they have a couple of DevOps guys who manage all the hosted tools mentioned above, but they spend most of their time pairing with delivery teams to improve automation processes. This is getting more important now that the teams are [validating their product decisions with split tests](http://danny.is/writing/delivering-business-kanban-and-validated-learning-150314). There are also a couple of Agile Coaches and Data Analysts who tend to join teams as and when their expertise is required.

The company's engineering and business practices are all recorded in a comprehensive [playbook](http://playbook.thoughtbot.com), which anyone can contribute to via pull request --- subject to the usual code review process, of course.

The COO used to be a developer, and likes to pair with team members occasionally. The rest of the leadership team is heavily involved in sales, but speak daily to make sure they're on the same page. There is a bi-weekly meeting with all the product owners and the COO, which is normally attended by at least a couple of the other senior stakeholders. There are also regular demos, where teams show off their work to the rest of the company.

The leadership team value transparency, and have a clear vision of the firm they want to build. They're also incredibly passionate about their products, something which filters down to their staff. They understand the term "servant leader".

Unlike the delivery teams, they view the product suite as a whole, and have a high-level road-map. Through regular conversation with the product owners, they identify new features and projects to work on, as well as new experiments to run. All of these projects go into a prioritised *Company Backlog* --- they're usually pretty big. Most of these get picked up by product owners who break them into user stories and add them to product backlogs.

This is all facilitated by a big-picture Kanban board that shows the leadership team where everything's at, and a WIP limit is used to throttle the amount of work and direct teams towards any bottlenecks in this big-picture flow.

When something goes wrong, as it sometimes does, they hold a [Five Why's Meeting](https://hbr.org/2010/04/the-five-whys-for-startups) to find the root cause, and then take action to rectify it.

It's a fairly simple system.

---

Does this company need a complex framework to scale agile? **Absolutely not**. They have a simple way to facilitate the flow of business value from top to bottom, and to coordinate work. Could this company scale? They'd have some work to maintain their culture, but their process could certainly scale. It might need the introduction of another management layer, but the process is fundamentally sound.

How many companies are at this stage, though? How many companies have eliminated onerous or ineffective processes and improved collaboration to the point where a suitable system can form organically? Most importantly, how many companies have the culture of transparency and **trust** that is required to support this? Without the right culture, an effective system is unlikely to grow from self-organizing teams. Particularly in Enterprise.

{{image: 2}}

If we can't grow our own system, we need to buy one off-the-shelf. That’s why we need scaled agile frameworks like SAFe.

# What is SAFe?

Much has been written about the Scaled Agile Framework (for Enterprise). Ken Schwaber is [clearly not a fan](https://kenschwaber.wordpress.com/2013/08/06/unsafe-at-any-speed/) and while Ron Jeffries has a [slightly more balanced](http://ronjeffries.com/xprog/articles/safe-good-but-not-good-enough/) view, Neil Killick describes it as a [horrible, pure money-making bastardisation and Frankenstein of Scrum, Agile and Waterfall](http://neilkillick.com/2012/03/21/the-horror-of-the-scaled-agile-framework/). I'm not sure that's fair.

At its core, SAFe recommends a bunch of very sensible stuff. It recognizes the importance of actual leadership, mandates high code quality and introduces three layers: Portfolio, Programme and Team. Each layer has a more granular backlog, facilitating the flow of value from business goals to user story. It recommends analyzing the Cost of Delay, applying WIP limits in the top level board, and has a general focus on Lean thinking. Interestingly, SAFe suggests starting a transformation at programme level rather than at the portfolio or team level. It is usually far easier to show the value of change management in this middle layer.

I have two major criticisms of SAFe.

#### Criticism One - This Picture

{{image: 1}}

It is the sort of diagram we're used to seeing on [leaked NSA Slides](http://www.slideshare.net/EmilandDC/dear-nsa-let-me-take-care-ou). It's *horrible*. It's also very well suited to the SAFe's target market: large enterprise companies looking for a process that they can understand.

#### Criticism Two - It's not very 'Agile'

For an Agile framework, SAFe seems to have a strong emphasis on centralized control, and much thought has been put into the management of process dependencies. These both smell of [Taylorism](http://en.wikipedia.org/wiki/Frederick_Winslow_Taylor) and are directly opposed to the agile notions of self-organising, independent teams.

There are a whole host of other reasons that SAFe and its friends[^1] aren't particularly agile, but the big question is this: do they serve a purpose?

# SAFe as a Gateway Drug

Kanban is rooted in four basic principles:

1. Start with the Existing Process
2. Agree to pursue incremental, evolutionary change
3. Respect the current process, roles, responsibilities and titles
4. Leadership at all levels

It's my view that methodologies like SAFe are rooted in these, but are born of the high cost and inherent difficulty in changing a whole company from one way of thinking to another.

Any large-scale organizational change is difficult. Agile transformations are even harder, since they seek to radically alter culture, process and working practice across a whole organization, often at the same time.

Although there are many ways to effect change, the Kanban principles tell us to start with the existing process and respect it, as well as the people in it. Whereas a traditional change programme might aim to incrementally improve parts of the organization, SAFe offers an out-of-the-box solution that is radical enough to seem worthwhile, but familiar enough to seem possible.

It respects the realities of software engineering in large enterprises. It includes things that are considered bad, but also common. Hardening sprints are the obvious example, but there are plenty more.

Transformation exists to allow an organisation to transition from one state to another. Often from a monolithic behemoth with complex inter-dependent systems & processes and a multitude of conflicting internal cultures, to a streamlined collection of independent teams, whose work is aligned with the business vision and whose separate but similar cultures mean they're all 'pulling in the same direction'.

However, if the adoption of SAFe is seen as the end goal of a transformation, we have missed the point. It should be seen as a stepping stone to a more intrinsically agile organization.

It's interesting to note that many respondents to the most recent *State of Agile* survey cited consistent process, executive sponsorship and common tooling as the factors that most helped them scale agile.

{{image: 3}}

Although executive buy-in in clearly important---I dislike the term 'sponsorship' since it implies only a passing involvement---most people I know would agree that a truly agile organization would empower it's teams to choose the processes and tools that best suited them.

# To Conclude

[Domonic Maximini](http://scrumorakel.de/blog/index.php?/archives/45-A-critical-view-on-SAFe.html)'s article *A Critical View on SAFe* does a good job of summing up:

<blockquote>It all can be summed up the following way:
<ul><li><span>SAFe believes that the world is good as it is and the existing companies, processes and structures created that world. So the status quo has to be accommodated.</span></li>
    <li><span>Agile believes that the world is not a good place (at least for people working in software development) and should be improved. The status quo – especially the tayloristic thinking - has to be changed.</span></li></ul>
<footer>Domonic Maximini</footer>
</blockquote>

SAFe should be seen as a gateway drug, or set of training wheels. But we mustn't forget the end goal --- developing a *truly* agile orgainzation, in both process and culture.

In the same way that Scrum can fail because teams forget to introspect, learn and improve; SAFe could fail at the organizational level. That said, it's got to be better than [the alternative](http://www.lafable.com).

[^1]: Large Scale Scrum (LeSS), Disciplines Agile Development (DAD), Enterprise Agile/Scrum, Recipes for Agile Governance in Enterprise (RAGE) and Agile Product Management (APM). 
