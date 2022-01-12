# README - tickler scripts

This is based off Braden Grams tickle work that used to be at [bgrams github](http://github.com/bgrams)

## Manual work to use tickle scripts

There is only one manual task to be done, adding TICKLER_DIR variable in your config file .cfg. Then if this directory structure is not there, the first run of the tickler action will create it.

I have integrated this tickle directory and files in to my other scripts to enable notes in tickle files to be see as current for example.

## Tickle

Tickle takes an item from the todo.txt file and adds to a month or day file.

Usage: ```todo.sh tickle 2 m3``` to move item to into march file or ```todo.sh tickle 4 16d``` which moves the fourth item into day 16 file.

## Tickled

Tickled shows a chronological list of all future tasks. So you can move/remove future tasks if required.

Usage: ```todo.sh tickled```

## Tickler

Tickler handles moving tickled items into your todo file. This can be run from cron on a daily basis, or simply run manually to catch up at any time. The best guess is made when run manually, so anything between the last run and now is pushed to the todo file. When moved the items are prepended with the variable TICKLE_PREPEND if it exists in the todo.cfg file. This makes it obvious what items are new from your 43 folders and can be tidied up when you prioritize next.

Usage: ```todo.sh tickler```
