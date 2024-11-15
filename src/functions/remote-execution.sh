#!/bin/bash

function tw-ssh-proxysql-us-all() {
 for i in {1..7}; do
   echo "Target machine: proxysql-us-${i}"
   echo "Executing command \"${@}\""
   ssh -i ~/.ssh/Teamwork/proxysql.pem ubuntu@proxysql${i} -- bash -c "${@}"
 done 
}

function tw-ssh-haproxy-us-all() {
 for i in {1..3}; do
   echo "Target machine: haproxy-us-${i}"
   echo "Executing command \"${@}\""
   ssh -i ~/.ssh/Teamwork/haproxy.pem ubuntu@haproxy-${i}-us -- bash -c "${@}"
 done 
}

function tw-ssh-haproxy-eu-all() {
 for i in {1..3}; do
   echo "Target machine: haproxy-eu-${i}"
   echo "Executing command \"${@}\""
   ssh -i ~/.ssh/Teamwork/haproxy.pem ubuntu@haproxy-${i}-eu -- bash -c "${@}"
 done 
}

