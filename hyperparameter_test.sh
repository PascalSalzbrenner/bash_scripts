#!/bin/bash

# script to generate a series of EDDPs for a hyperparameter test

r_min=$1 # minimum rcut
r_max=$2 # maximum rcut
p_min=$3 # minimum number of polynomials
p_max=$4 # maximum number of polynomials
chain_command_line=$5 # chain parameters other than rcut and polynomials

if [ ! -f hyperparameter_test.dat ]; then
	echo "# -r [Ang]; -P; Attempt number; RMSE [meV/atom]; MAE [meV/atom]" > hyperparameter_test.dat
fi

if [ ! -f hyperparameter_test_average.dat ]; then
        echo "# -r [Ang]; -P; RMSE [meV/atom]; MAE [meV/atom]" > hyperparameter_test_average.dat
fi

for rcut in `seq $r_min $r_max`; do
	for p in `seq $p_min $p_max`; do
		for i in `seq 1 3`; do

			if [ ! -d attempt_r_${rcut}_P_${p}_${i} ]; then
        	
				mkdir attempt_r_${rcut}_P_${p}_${i}
				cp *.cell *.param data.res attempt_r_${rcut}_P_${p}_${i}
        	
				cd attempt_r_${rcut}_P_${p}_${i}
				chain $chain_command_line -r $rcut -P $p 1> chain.out 2> chain.out
				rmse=`awk '/testing:    testing RMSE/ {print $4}' chain.out | tail -1`
				mae=`awk '/testing:    testing RMSE/ {print $5}' chain.out | tail -1`
				cd ..
		
				echo $rcut $p $i $rmse $mae >> hyperparameter_test.dat
        	
			fi

		done
			
		# average over the three EDDPs
		average_rmse=`awk -v pat="^$rcut $p" 'BEGIN { sum=0; count=0 } $0 ~ pat { sum+=$4; count++ } count==3 { print sum/3; exit }' hyperparameter_test.dat`
		average_mae=`awk -v pat="^$rcut $p" 'BEGIN { sum=0; count=0 } $0 ~ pat { sum+=$5; count++ } count==3 { print sum/3; exit }' hyperparameter_test.dat`
		echo $rcut $p $average_rmse $average_mae >> hyperparameter_test_average.dat
	done
done
