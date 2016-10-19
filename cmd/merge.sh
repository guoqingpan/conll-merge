#!/bin/bash
echo 'iterated CoNLLAlign of multiple documents, write to stdout' 1>&2
echo 'synopsis: '`echo $0 | sed s/'.*\/'//`' FILE1..n [CoNLLAlignFlags]' 1>&2;
echo '  FILE1..n        CoNLL annotations of the same document'1>&2;
echo '  CoNLLAlignFlags see CoNLLAlign for options (other than files)' 1>&2;

########
# prep #
########

CoNLLAlign=org/acoli/conll/CoNLLAlign;

HOME=`echo $0 | sed s/'\/[^\/]*$'/'\/'/`./;
HOME=`cd $HOME; pwd`;

# Un*x setup
LIB=`cd $HOME/../lib; pwd`;
SRC_U=`cd $HOME/../src; pwd`;													# Un*x version of SRC
SRC=$SRC_U;																		# OS-specific version of SRC
CLASSPATH=$SRC_U`for file in $(find $LIB | grep jar$); do echo -n ':'$file; done;`

# Cygwin setup
if echo $OSTYPE | grep -i cygwin >/dev/null; then
	SRC=`cygpath -wa $SRC_U | perl -pe 's/\n//g;'`;
	CLASSPATH=$SRC`for file in $(find $LIB | grep jar$); do echo -n ';'; cygpath -wa $file | perl -pe 's/\n//g;'; done;`
fi;

# compile, if necessary
if [ -e $SRC_U/$CoNLLAlign.class ] ; then
	if [ $SRC_U/$CoNLLAlign.java -nt $SRC_U/$CoNLLAlign.class ]; then rm $SRC_U/$CoNLLAlign.class; fi;
fi;

STATUS=nok;

if [ -e $SRC_U/$CoNLLAlign.class ] ; then 
	STATUS=ok;
else 
	if javac -cp $CLASSPATH $SRC/$CoNLLAlign.java; then
		STATUS=ok;
	fi;
fi;

if [ $STATUS = 'ok' ]; then 

	#######################
	# iterated CoNLLAlign #
	#######################
	TMP=$0.tmp;
	while [ -e $TMP ]; do
		TMP=$0.`ls $0*tmp |wc -l`.tmp;
	done;
	for file in $*; do
		if [ -e $file ]; then
			if [ ! -e $TMP ]; then 
				cp $file $TMP;
				echo 1>&2;
				echo add $file 1>&2;
			fi;
		fi;
	done;
	TMP2=$TMP.bak;

	SPLIT=`echo $* | sed s/'.*\(-split\).*'/'\1'/g | grep split`
	DROPCOLS=`echo $* | sed s/'.*\(-drop.*\)$'/'\1'/g | grep drop`
	F=`echo $* | sed s/'.*\(-f\)[ \t].*'/'\1'/g | grep '\-f'`
	
	for file in $*; do
		if [ $file != $1 ]; then
			if [ -s $file ]; then
				echo 1>&2;
				echo add $file 1>&2;
				java -cp $CLASSPATH $CoNLLAlign $TMP $file -silent $SPLIT $F $DROPCOLS > $TMP2;
				mv $TMP2 $TMP;
			fi;
		fi;
	done;
	
	######################
	# output and cleanup #
	######################

	cat $TMP;
	rm $TMP;
fi;