__sortinlinetable__ is a small script that alphabetically sorts a table that is embedded in a larger file. It uses the standard unix utilities __which__, __grep__, __head__, __tail__ and __sort__.

It can for example sort a list of items inside a LaTeX file, or bring a CSV table into alphabetical order without touching the header line with the column names.

It detects the location of the table to be sorted with the help of arbitrary "mark" character sequences you supply. You can insert the mark sequences on purpose, or just utilise uniqu

##Installation

This short guide focusses on Linux; you might have to modify it somewhat for other operating systems.
">" here denotes the command line prompt.

1. Move the script file from its download and unpacking location to a directory in the path, for example:

 > sudo mv sortinlinetable.sh /usr/local/bin

2. Make sure the script file is executable but not world-writable:

 > sudo chmod a+x-w /usr/local/bin/sortinlinetable.sh

##Usage 

__sortinlinetable__ is invoked from a command line:

 > sortinlinetable.sh INFILE OUTFILE STARTMARK [ENDMARK]
 
This sorts the lines between STARTMARK and ENDMARK in INFILE alphabetically, writing both the sorted lines and anything before or after to OUTFILE.

INFILE must be an existant file.
OUTFILE will be overwritten if existant.
INFILE and OUTFILE must not be identical.

STARTMARK: Part of the line immediately preceeding the lines to be sorted.
ENDMARK: Part of the line immediately following the lines to be sorted.

STARTMARK and ENDMARK are case sensitive!
They will remain in place in the output and will not be removed.


This script uses the grep utility to find its marks,
so avoid using characters other than letters and numbers in STARTMARK and ENDMARK
unless you know what you are doing!

##Author and Copyright
__sortinlinetable__ is (C) 2017-2024 Matthias Jacobs.


