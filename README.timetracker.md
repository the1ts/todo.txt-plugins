# README - timetracker action

This action manipulates a time tracking file allowing you to keep track of and
report on the time spent on a project.

## Starting a timer

To start the timer on a project:

```todo.txt.sh timetracker on project```

## Stopping a timer

To stop the timer on a project:

```todo.txt.sh timetracker off project```

## Report on a timer

To report the status and time off a project, if the project is still active, it
will show upto the current time.

```todo.txt.sh timetracker status project```

To show the status and time of all projects, just ommit the project name
 todo.txt.sh timetracker status

## Archiving timetrack files

When you have completed a project you can archive projects to stop them appearing
in status requests. If the project is still counting up the project is ended at
the time of archiving.

## Listing timetracker files

You can list all the timetracker files currently in use and archived

```todo.txt.sh timetracker list```
