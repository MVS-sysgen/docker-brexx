#!/usr/bin/env bash

while [ ! -f /home/hercules/done.txt ]
do
  printf .
  sleep 1
done