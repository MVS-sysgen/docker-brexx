#!/usr/bin/env bash

echo "* Waiting for MVS3.8j to load"

while [ ! -f /home/hercules/done.txt ]
do
  printf .
  sleep 1
done

echo "* Done!"