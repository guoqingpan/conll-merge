#!/bin/bash
PATH_SEPARATOR=':';

FILES1=conll/*conll;
FILES2=conll/*conll;
# FILES1=conll/*rst*conll;	# conll/*conll
# FILES2=conll/*pdgb*conll;	# conll/*conll

if echo $OSTYPE | grep -i 'cygwin' >&/dev/null; then PATH_SEPARATOR=';'; fi;
if 
	javac -classpath ../src/$PATH_SEPARATOR../lib/diffutils-1.2.1.jar ../src/org/acoli/conll/*java;
then
		mkdir merge >& /dev/null;
		for file1 in $FILES1; do
			for file2 in $FILES2; do
				if [ $file1 != $file2 ]; then
					if echo $file1 $file2 | egrep 'prop.*rst' >/dev/null; then echo skipping merging of $file1 and $file2: rst must precede prop 1>&2;
					else
						TGT=merge/`echo $file1 | sed s/'.*\/'//`_`echo $file2 | sed s/'.*\/'//`.merged.conll;
						if [ -e $TGT ]; then echo found $TGT, skipping CoNLLAlign $file1 $file2 1>&2;
						else 
							echo run CoNLLAlign $file1 $file2 '>' $TGT 1>&2;
							java -classpath ../src/$PATH_SEPARATOR../lib/diffutils-1.2.1.jar org/acoli/conll/CoNLLAlign $file1 $file2 > $TGT
							echo 1>&2;
							
							if javac ../src/org/acoli/conll/CoNLLChecks.java; then
								java -classpath ../src org.acoli.conll.CoNLLChecks $TGT;
							fi;
							echo 1>&2;
						fi;
						
						TGT=merge/`echo $file1 | sed s/'.*\/'//`_`echo $file2 | sed s/'.*\/'//`.merged_f.conll;
						if [ -e $TGT ]; then echo found $TGT, skipping CoNLLAlign $file1 $file2 1>&2;
						else 
							echo run CoNLLAlign $file1 $file2 '>' $TGT 1>&2;
							java -classpath ../src/$PATH_SEPARATOR../lib/diffutils-1.2.1.jar org/acoli/conll/CoNLLAlign $file1 $file2 -f  > $TGT
							echo 1>&2;
							
							if javac ../src/org/acoli/conll/CoNLLChecks.java; then
								java -classpath ../src org.acoli.conll.CoNLLChecks $TGT;
							fi;
							echo 1>&2;
						fi;
						
						TGT=merge/`echo $file1 | sed s/'.*\/'//`_`echo $file2 | sed s/'.*\/'//`.merged_split.conll;
						if [ -e $TGT ]; then echo found $TGT, skipping CoNLLAlign $file1 $file2 1>&2;
						else 
							echo run CoNLLAlign $file1 $file2 '>' $TGT 1>&2;
							java -classpath ../src/$PATH_SEPARATOR../lib/diffutils-1.2.1.jar org/acoli/conll/CoNLLAlign $file1 $file2 -split  > $TGT
							echo 1>&2;
							
							if javac ../src/org/acoli/conll/CoNLLChecks.java; then
								java -classpath ../src org.acoli.conll.CoNLLChecks $TGT;
							fi;
							echo 1>&2;
						fi;

						TGT=merge/`echo $file1 | sed s/'.*\/'//`_`echo $file2 | sed s/'.*\/'//`.merged_split_f.conll;
						if [ -e $TGT ]; then echo found $TGT, skipping CoNLLAlign $file1 $file2 1>&2;
						else 
							echo run CoNLLAlign $file1 $file2 '>' $TGT 1>&2;
							java -classpath ../src/$PATH_SEPARATOR../lib/diffutils-1.2.1.jar org/acoli/conll/CoNLLAlign $file1 $file2 -split -f  > $TGT
							echo 1>&2;
							
							if javac ../src/org/acoli/conll/CoNLLChecks.java; then
								java -classpath ../src org.acoli.conll.CoNLLChecks $TGT;
							fi;
							echo 1>&2;
						fi;
					fi;
				fi;
			done;
		done;
fi;

