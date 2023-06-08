##timestep in fs
timestep=2

echo "---" >> ~/jobs.log
echo $(date) >> ~/jobs.log
echo $(pwd) >> ~/jobs.log
echo $(hostname) >> ~/jobs.log
echo "ramble -ompnp 28 -t -te 100 -ts $timestep -ncell 1000 -dr 0 -tt 800 -p 10 -m 1000 Po > ramble.out 2> ramble.err" >> ~/jobs.log
echo "---" >> ~/jobs.log

ramble -ompnp 28 -t -te 100 -ts $timestep -ncell 1000 -dr 0 -tt 800 -p 10 -m 1000 Po > ramble.out 2> ramble.err
