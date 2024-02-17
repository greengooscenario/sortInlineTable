__sortInlineTable__ is a small bash script that alphabetically sorts a table that is embedded in a larger file. It uses the standard unix utilities _which_, _grep_, _head_, _tail_ and _sort_.

It can for example sort a list of items inside a LaTeX file, or bring a CSV table into alphabetical order without touching the header line with the column names.

It detects the location of the table to be sorted with the help of arbitrary "mark" character sequences you supply. You can insert the mark sequences on purpose, or just utilise unique character combinations that are already there.

# Installation

_This short guide focuses on Linux; you might have to modify it somewhat for other operating systems._

"$>" here denotes the command line prompt.

1. Change into the directory to which you have unpacked your _sortInlineTable_ download

2. Make sure the script file is executable but not world-writable:

 $> `sudo chmod a+x-w sortinlinetable.sh`

3. Move the script file to a directory in the executable path, for example:

 $> `sudo mv sortinlinetable.sh /usr/local/bin/`

The third step is optional; you can just call sortinlinetable as "`./sortinlinetable.sh`" instead.


# Usage 

_sortinlinetable_ is invoked from a command line:

 $> `sortinlinetable.sh INFILE OUTFILE STARTMARK [ENDMARK]`
 
This sorts the lines between STARTMARK and ENDMARK in INFILE alphabetically, writing both the sorted lines and anything before or after to OUTFILE.

INFILE must be an existant file.
OUTFILE will be overwritten if existant.
INFILE and OUTFILE must not be identical.

STARTMARK: Part of the line immediately preceeding the lines to be sorted.
ENDMARK: Part of the line immediately following the lines to be sorted. Defaults to LaTeX command "_end{_", if not given explicitly.

STARTMARK and ENDMARK are case sensitive!
They will remain in place in the output and will not be removed.


This script uses the grep utility to find its marks,
so avoid using characters other than letters and numbers in STARTMARK and ENDMARK
unless you know what you are doing!


# Author and Copyright
sortInlineTable is (C) 2017-2024 Matthias Jacobs.

It is licensed under GPL v3.0, or any later version at your discretion.
See file LICENSE for further information.

