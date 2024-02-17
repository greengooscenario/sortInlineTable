#!/bin/bash
# this script sorts a table that is embedded in a larger file,
# leaving anything before and after the table as is.

if ((test -z "$3") || (!(test -r "$1")))  # if length of string $3 is zero, too few parameters have been given! The first parameter "INFILE" must be an existant, readable file!
then
    echo "Usage:" 
	echo $0 "INFILE OUTFILE STARTMARK [ENDMARK]"
	echo
	echo "Sorts the lines between STARTMARK and ENDMARK in INFILE alphabetically, writing both the sorted lines and anything before or after to OUTFILE."
	echo
    echo "INFILE must be an existant file."
	echo "OUTFILE will be overwritten if existant."	
	echo "INFILE and OUTFILE must not be identical."
	echo "STARTMARK: Part of the line immediately preceeding the lines to be sorted."
	echo "ENDMARK: Part of the line immediately following the lines to be sorted."
	echo "These marks will remain in place in the output and will not be removed."
	echo
	echo "STARTMARK and ENDMARK are case sensitive!"
	echo "This script uses the grep utility to find the marks,"
    echo "so avoid using characters other than letters and numbers in STARTMARK and ENDMARK" 
	echo "unless you know what you are doing."

	exit 1
fi

STARTMARK=$3
INFILE=$1
OUTFILE=$2

if test $INFILE = $OUTFILE 
then {
        echo "Error: Input file = output file. Must be different files."
        exit 1
}
fi

if [ -n $4 ] # a 4th parameter has been given
then
	ENDMARK=$4
fi


######################################################
# Let's test for the helper programs this script needs:
echo " Checking for helper programs..."
if test -z $(which which) #this machine lacks the which utility
then
	echo "This machine lacks the \"which\" utility." 
	echo "This program needs the \"which\", \"grep\", \"sort\", \"head\" and \"tail\" commands. Terminating."
	exit 1
fi 

if test -z $(which sort) #this machine lacks the sort utility
then
	echo "This machine lacks the \"sort\" utility."
	echo "This program needs the \"which\", \"grep\", \"sort\", \"head\" and \"tail\" commands. Terminating."
	exit 1
fi
if test -z $(which grep) #this machine lacks the grep utility
then
	echo "This machine lacks the \"grep\" utility." 	
	echo "This program needs the \"which\", \"grep\", \"sort\", \"head\" and \"tail\" commands. Terminating."
	exit 1
fi
if test -z $(which head) #this machine lacks the head utility
then
	echo "This machine lacks the \"head\" utility."
	echo "This program needs the \"which\", \"grep\", \"sort\", \"head\" and \"tail\" commands. Terminating."
	exit 1
fi
if test -z $(which tail) #this machine lacks the tail utility
then
	echo "This machine lacks the \"tail\" utility."
	echo "This program needs the \"which\", \"grep\", \"sort\", \"head\" and \"tail\" commands. Terminating."
	exit 1
fi
echo "...all present."

if test -n $(which mktemp) #this machine has the mktemp utility installed
then
	TMPFILEA=$(mktemp sortinline.XXXX.tmp)
	TMPFILEB=$(mktemp sortinline.XXXX.tmp)
else
	echo "This machine lacks the \"mktemp\" utility."
	echo "I can handle this, but do not try to run" 
	echo "several instances of this program at once!"
	TMPFILEA="1.sortinlinetable.tmp"
	TMPFILEB="2.sortinlinetable.tmp"
fi


function cleanexit { # clean up the temporary files and exit with the given return value. 
	rm $TMPFILEA
	rm $TMPFILEB
	echo " Bye!"
	exit $1
}


###################################################################
#Begin of actual code

if test $(grep -G -c "$STARTMARK" $INFILE) = "1"  # if the mark can be found exactly once...
then 
        echo " start mark is valid:"
	grep -G -Hn -m 1 "$STARTMARK" $INFILE

	LINENUM=$(wc -l < $INFILE) #how many lines has infile?
	echo " file has $LINENUM lines..." 
	#Anything before the mark, and the line containing the mark go into outfile unchanged:
	grep -G --color=never -m 1 -B $LINENUM "$STARTMARK" $INFILE > $OUTFILE
	#The line containing the mark and anything after it go into a temporary file:
	grep -G --color=never -m 1 -A $LINENUM "$STARTMARK" $INFILE > $TMPFILEA
	#The line containing the mark gets removed:
	tail -n $(($(wc -l < $TMPFILEA) -1)) $TMPFILEA > $TMPFILEB	



	if [ -z $ENDMARK ] #If the user has not supplied an endmark, we assume ENDMARK='end{' 
	then
		echo WARNING: The user did not supply an end mark - assuming "\"end{\""
		ENDMARK='end{'
	fi	
	if test $(grep -G -c $ENDMARK $TMPFILEB) = "0"
	then
		echo "end mark \"$ENDMARK\" is before start mark or does not exist"
		echo "- Please supply a different one!"
		cleanexit 1
	fi
	echo " end mark is valid:"
	grep -G -m 1 $ENDMARK $TMPFILEB


	#the target lines before the endmark and the line containing endmark go to a temporary file:
	grep -G --color=never -m 1 -B $LINENUM $ENDMARK $TMPFILEB >   $TMPFILEA
	#the last line, containing the endmark, not part of the target, is discarded; the result is sorted and added to outfile:
	head -n $(($(wc -l < $TMPFILEA)-1)) $TMPFILEA |sort -hbf >> $OUTFILE
	#the line with the endmark and all following lines go to the outfile:
	grep -G --color=never -m 1 -A $LINENUM $ENDMARK $TMPFILEB >> $OUTFILE
	echo "...$OUTFILE written."
        cleanexit 0
##################################################################
else #the start mark can be found more then once, or not at all...
	echo "The mark \"$STARTMARK\" is not unique, or it cannot be found in $INFILE."
	echo "Please supply a unique start mark."
	cleanexit 1
fi
