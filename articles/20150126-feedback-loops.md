title: Agile Feedback Loops
post_id: 10
slug: feedback-loops

#!!==========================================================


Feedback loops are a fairly key part of agile development. The process of doing something, getting feedback and then learning from it crops up everywhere: from Lean Product Management to Scrum Retrospectives to the XP practaces of pair programming and TDD. In my experience, there are hunderds of loops providing feedback during agile software development. Here are my thoughts on a few of them...

## Unit Tests and Pair Programming
Unit tests are the 'smallest' of feedback loop. If a developer is using TDD, he should be using unit tests to drive his development, providing quick feedback every few minutes. Pairing is also a form of feedback, since developers will constantly discuss the best options with each other. The length of these feedback loops is typically very short – two or three minutes.

## Automated Functional Tests
Automated integration, system and acceptance testing can be conducted before a developer pushes code to a central repository like GitHub. These might include acceptance tests written with a tool like [Cucumber](https://cukes.info).

Although it might be prohibitively slow for a developer to run a full suite locally, he'll probably run the tests that cover the story he's been working on. If he's using a feature-branch workflow, a full suite could be run on a CI server whenever he pushes to his branch. The length of these feedback loops is typically a little longer: perhaps every hour or so, perhaps shorter.


## Continuous Integration & Code Reviews
A good CI tool can be configured to run a full suite of regression tests, usually including all unit, integration and acceptance tests. This might happen before a feature branch is merged into master – GitHub pull requests are great for this.

{{image: 1}}

It's also possible to provide aditional automated feedback from tools like [Hound](https://houndci.com/repos), which checks code against a styleguide; [CodeClimate](https://codeclimate.com), which gives an indication as the the quality of a codebase; and [Coveralls](https://coveralls.io), which indcates what code is covered by tests. Because all of these can be tied to both a CI server and GitHub, they can provide very quick feedback that can be automatically appended to a pull request.

The length of this feedback loop is typicaly a little longer still: usually after a user story has been completed. Of course, depending on how a team works, these could run against pushes to feature branches and the loop would be much shorter.

{{image: 2}}

All of this can make the process of manual code reviews quicker and faster. A manual code review typically has a slightly longer feedback loop, since it's not automated, but it still provides fairly quick feedback on how well a feature has been built.

{{image: 3}}

## Sprint Demos and Releases
Presuming a team is working iteratively, sprint reviews offer an opertunity to get feedback from product owners, customers and other stakeholders. If the software is released into a UAT environment at the end of each sprint, then its possible to get feedback from a small group of real users too. In my experience though, this doesn't happen as much as it should.

While the feedback loops discussed up to now are aimed at helping developers build *the the thing right*, demos and feedback from users is intended to help us understand wether we are building *the right thing*.

## Periodic Releases
Every few sprints, a team might release some software into production. This provideas an oppertunity to gather feedback from real users by observing their behaviour with analytics tools.

{{image: 4}}

# Question

As developers and agile coaches, we spend a fair bit of time trying to reduce the size of the feedback loops concerned with *building the the thing right*, but short of reducing the length of an interation, we don't seem to aply the same effort to decreasing those concerned with *building the right thing*.

Other than suggesting that we prototype new features and trial them with real users, I don't have the answer right now. But here's my question: how can we reduce the length of feedback loops concerned with building the right thing?

In other words, how can we get faster feedback from actual users to inform business and product decisions? This will ultimately help to reduce the risk associated with making something that doesn't offer real business value.





