#!/bin/bash

if [ -n $1 ]; then
  cat /proc/$1/status
else
  echo "Argument not provider"
  exit 1
  fi
