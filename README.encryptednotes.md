# README - Encrypted Notes and Archived Encrypted Notes

## Encrypted Notes actions

The enotes adds an encrypted note taking ability to todo.txt shell script. It enables you to add encrypted notes files associated with one or many tasks in your todo file or files.

The syntax is enote:notesfile and this can be added to one or many todo items.

There are a couple directories used by these notes actions.

1. TODO_DIR/notes directory for active notes files
2. TODO_DIR/notes/archive used to hold archived notes with time stamps prepended

NB. make sure the enote name is a single word (no spaces, so use - or _ for multiple words), this is the same restriction as projects and contexts. Encrypted notes actions also know about files created with the tickle action (43 folders). The enotes files are in the format prefix-notename.gpg so they can be found and opened by gpg or vim with gpg plugin.

### Add an encrypted note

Add an encrypted note to an item line or lines via enotesadd action.

Usage: ```todo.sh enotes add enote:test_enote 1```

### Editing encrypted notes

Encrypted notes can only be edited if the enote is in the todo.txt file.

Usage: ```todo.sh enotes edit note_name```.

### Listing encrypted notes

To list active encrypted notes run listenotes, you will get a list of all active encrypted notes in your todo.txt file. It also takes an option which displays only those matching a grep of enotes file names.

Usage: ```todo.sh enotes list``` or ```todo.sh enotes list testing```

### Showing encrypted notes

To show enotes, there is a enotes cat action.

Usage: ```todo.sh enotes cat notes_name```

### Grep encrypted notes

To find those encrypted notes that contain a word or phrase, they are listed in the enote:notename format for easy copy paste.

Usage: ```todo.sh enotes grep testing```

## Archive encrypted notes

When you have done all tasks associated with an enotes file you can archive the enotes file. Archiving moves the enotes file to the TODO_DIR/notes/archive directory and adds the date and time of archiving to the file name. This way you can track enotes over time.

### Archiving encrypted notes

The enotesarchive action simply moves all enotesfiles nolonger in the todo.txt file.

Usage: ```todo.sh enotes archive```

### Unarchive encrypted notes

The enotesunarchive action can be used to copy the latest archived version of an enotesfile back to current.

Usage: ```todo.sh enotes unarchive enote:test_note```

### Listing archived encrypted notes

To list archived notes run listarchivedenotes, you will get a list of all archived enotes in your todo directory. It also takes an option which displays only those matching a grep of enotes file names

Usage: ```todo.sh enotes listarchived test```
