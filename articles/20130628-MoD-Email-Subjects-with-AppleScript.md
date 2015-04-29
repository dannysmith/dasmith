title: MoD Email Subjects with AppleScript
post_id: 13
slug: mod-email-subject-lines-with-applescript-osx

#!!==========================================================

The work I do with the RAF and Army requires me to send emails with the date and security classification included, like this: "20130628-The Subject-U".

{{image: 1}}

I must do this at least 30 times a day, and earlier on I was that fed up with copy/pasting dates that I decided to write a script to do it for me. I did try this once before, but Mail.app's API wasn't very robust at the time and the action relied upon simulating keypresses which wasn't exactly reliable.

The following script adds the date and PM to the subject of the foremost Compose Mail Window. It's a little smarter than my previous attempt too, in that it replaces the date if it's already there and leaves the PM alone if it exists already.

{{gist: https://gist.github.com/dannysmith/5887954}}

This one opens a reply to the selected message, with the "Re:" in the right place:

{{gist: https://gist.github.com/dannysmith/5888072}}

Using Applescript is awkward to say the least - [Russell Beattie](http://www.russellbeattie.com/blog/fun-with-the-os-x-finder-and-applescript) puts it quite well

<blockquote>
Using AppleScript is like being tied down in a black leather gimp-suit at a dominatrix convention, and losing the safety word... The syntax is like Erlang and ancient Greek got somehow mixed together with Visual Basic, and was translated back into English by mentally-challenged ESL students
</blockquote>

I did try to make a plugin for Mail.app to add some buttons to the menubar, but after discovering how [difficult](http://eaganj.free.fr/weblog/?post/2009/07/14/Demystifying-Mail.app-Plugins-on-Leopard) it is working with Mail.app's undocumented API, I gave up, [created a Service using Automater](http://macgrunt.com/2012/07/31/turn-an-applescript-into-a-service/) and added some workflows to Alfred 2.

As I have to rename files in a similar manner, this script renames the currently selected file in finder:

{{gist: https://gist.github.com/dannysmith/5888471}}
