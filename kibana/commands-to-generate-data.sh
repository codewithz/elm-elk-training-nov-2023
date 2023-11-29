#-- Check the version of ElasticSearch

curl -XGET http://localhost:9200 

let say your version is 8.2.0 


sudo apt-get install metricbeat=8.2.0 

sudo systemctl start metricbeat

sudo apt install stress

# To check the number of processor 
nproc

# To check the free space 

free -h

# Run the logs on CPU

stress --cpu 1 --timeout 120

stress --vm 5 --timeout 180


