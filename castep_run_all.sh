#!/bin/bash

for i in */; do
	
	cd $i

	# auto-determine fileroot
	name=`ls *.param`
	fileroot=`python3 -c "print('$name'.split('.')[0])"`

	mpirun -n $NCORES castep.mpi $fileroot

	cd ..

done
