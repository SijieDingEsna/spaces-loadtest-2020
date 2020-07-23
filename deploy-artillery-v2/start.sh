#!/bin/bash

gcp_project="onesnastaging"
cluster_name="artillery-vu"
zone="us-central1-a"
directory = ""

while [ "$1" != "" ]; do
  case $1 in
    -p | --project ) shift
                  gcp_project=$1
                  ;;
    -c | --cluster) shift
                  cluster_name=$1
                  ;;
    -z | --zone) shift
                 zone=$1
                 ;;
    -d | --directory) shift
                 directory=$1
                 ;;
    -h | --help) need_help=true
                 break
                 ;;
  esac
  shift
done

if [ "$need_help" = true ]; then
  echo "Options:"
  echo ""
  echo "-h, --help      output usage information"
  echo "-p, --project   The project name in gcp, default value is onesnastaging"
  echo "-c, --cluster   The cluster name of kubernetes, default value is artillery-vu"
  echo "-z, --zone      THe zone of the the cluster, default value is us-central1-a"
  echo "-d, --directory The directory of the files will be executed in kubernetes."
  exit
fi

if [[ -z "$directory" ]]; then
  echo "Must set directory of the files will be deployed to kubernetes"
  exit 1
else
  ehco "Will deploy the directory ${directory} to the cluster"  
fi

#Connect to the cluster
echo "Connect to the cluster now"
CMD="gcloud container clusters get-credentials $cluster_name --zone=$zone --project=$gcp_project"
echo $CMD
$CMD
status=$?
if [[ $status -eq 0 ]]; then
  echo "Connect to the cluster $cluster_name successfully!"
else
  echo "Create to the cluster $cluster_name failed!"
  exit 1
fi

#Create secret of the 
