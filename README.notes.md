# README - Notes and Archived Notes

## Notes actions

These actions are to create a note taking ability to todo.txt shell script. It enables you to add notes files associated with one or many tasks in your todo file or files.

The syntax is note:notesfile and this can be added to one or many todo items.

There are a couple directories used by these notes actions.

1. TODO_DIR/notes directory for active notes files
2. TODO_DIR/notes/archive used to hold archived notes with time stamps prepended

NB. make sure the note name is a single word (no spaces, so use - or _ for multiple words), this is the same restriction as projects and contexts. Notes actions also know about files created with the tickle action (43 folders). The notes files are in the format prefix-notename.txt

### Add a note

Add a note to an item line or lines via notesadd action.

Usage: ```todo.sh notesadd note:test_note 1```

### Editing notes

Notes can only be edited if the note is in the todo.txt file.

Usage: ```todo.sh notesedit note_name```.

### Listing notes

To list active notes run listnotes, you will get a list of all active notes in your todo.txt file. It also takes an option which displays only those matching a grep of notes file names.

Usage: ```todo.sh listnotes``` or ```todo.sh listnotes testing```

### Showing notes

To show notes, there is a notescat action.

Usage: ```todo.sh notescat notes_name```

### Grep notes

To find those notes that contain a word or phrase, they are listed in the note:notename format for easy copy paste.

Usage: ```todo.sh notesgrep testing```

## Archive notes

When you have done all tasks associated with a notes file you can archive the notes file. Archiving moves the notes file to the TODO_DIR/notes/archive directory and adds the date and time of archiving to the file name. This way you can track notes over time.

### Archiving notes

The notesarchive action simply moves all notesfiles nolonger in the todo.txt file.

Usage: ```todo.sh notesarchive```

### Unarchive notes

The notesunarchive action can be used to copy the latest archived version of a notesfile back to current.

Usage: ```todo.sh notesunarchive note:test_note```

### Listing archived notes

To list archived notes run listarchivednotes, you will get a list of all archived notes in your todo directory. It also takes an option which displays only those matching a grep of notes file names

Usage: ```todo.sh listarchivednotes test```