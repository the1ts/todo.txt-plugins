#!/bin/bash
CFG_FILE=$1
. "$CFG_FILE"
TODAY_DIR="$TICKLER_DIR/today/"
today=$(date '+%d');
thismonth=$(date '+%m');
defaulttext="check "
statefile="$TICKLER_DIR/.tickler_month_state.txt"
tickler_month_state=`cat $statefile`

# copy all items into todo.txt and remove todays file
cat $TICKLER_DIR/days/$today/$today.txt >> "$TODO_FILE"
rm -rf $TICKLER_DIR/days/$today/$today.txt

# copy all items from folder with todays date to folder named 'today'
for i in $( ls $TICKLER_DIR/days/$today  ); do
	    echo $i
		mv $TICKLER_DIR/days/$today/${i} $TODAY_DIR/
		echo $defaulttext $TODAY_DIR/${i} >> "$TODO_FILE"
done
touch $TICKLER_DIR/days/$today/$today.txt 

# test to see if we have a state file
if [ -e $statefile ]
    # if we have a state file then process it
then
    if [ "$thismonth" -ne "$tickler_month_state" ]
        # if this month is not the same as the month in which the script was last run and recorded it's state
    then
        # copy all items into todo.txt and remove this months file
        cat $TICKLER_DIR/months/$thismonth/$thismonth.txt >> "$TODO_FILE"
        rm -rf $TICKLER_DIR/months/$thismonth/$thismonth.txt

        # copy all items from folder from this month to folder named 'today'
        for i in $( ls $TICKLER_DIR/months/$thismonth  ); do
                    echo $i
                        mv $TICKLER_DIR/months/$thismonth/${i} $TODAY_DIR/
                        echo $defaulttext $TODAY_DIR/${i} >> "$TODO_FILE"
        done
        touch $TICKLER_DIR/months/$thismonth/$thismonth.txt 
        # put value of $thismonth from this run into a file so we can check to see if
        # this month has been processed yet on the next run (this allows things
        # to be put back into the month file for use in the next year
        echo $thismonth > $TICKLER_DIR/.tickler_month_state.txt
    fi
else
    # if no statefile create one with month 00---this will ensuer that the
    # current monthdir is processed since no previous state is known
    echo "00" > $statefile
fi
exit 0
