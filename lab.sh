#!/bin/bash
student_data(){
    #Fill Student Data
    read -p "Enter Your Full Name: " name
    echo "$name" > /tmp/name
    read -p "Enter Your Email: " email 
    echo "$email" > /tmp/email
    read -p "Enter Your RHNID: " rhnid
    echo "$rhnid" > /tmp/rhnid
    read -p "Enter Your Mentor Name: " mentor
    echo "$mentor" > /tmp/mentor
    echo ""
}

start_epel(){
    
}

send_data(){
    exercise_name=$(cat /tmp/exercise)
    mentor=$(cat /tmp/mentor)
    name=$(cat /tmp/name)
    email=$(cat /tmp/rhnid)
    score=$(cat /tmp/score)
    status=$(cat /tmp/status)
    id="https://script.google.com/macros/s/AKfycbzo4gj6N73xUcF0w0licSyWBqQp8YO2SWTCYhx7zINVa6Bw3k603kGHaNXEctXQufTv2Q/exec"
    curl -X POST \
    "$id" \
    -d "exercise=$exercise_name" \
    -d "mentor=$mentor" \
    -d "name=$name" \
    -d "email=$email" \
    -d "rhnid=$rhnid" \
    -d "total=$score" \
    -d "status=$status" &>/dev/null
}


if [ "$1" == "start" ];then
    student_data
    exercise_name=$2
    if [ "$2" == "epel" ];then
        exercise_name="Extra Packages for Enterprise Linux (EPEL) for RHEL"
        start_epel
    elif [ "$2" == "challenge-leapp" ];then
        exercise_name="Challenge: Upgrade to Red Hat Enterprise Linux 9 in place with LEAPP"
        
    elif [ "$2" == "run-container" ];then
        exercise_name="Running containers on Red Hat Enterprise Linux"

    elif [ "$2" == "build-container" ];then
        exercise_name="Build container images with Red Hat Enterprise Linux container tools"
    
    elif [ "$2" == "app-container" ];then
        exercise_name="Build an App Into Container Image"
    
    elif [ "$2" == "challenge1-container" ];then
        exercise_name="Challenge: Build Simple Apache Website Using Your Own Containerfile and Push The Container Image To quay.io Registry"
    
    elif [ "$2" == "challenge2-container" ];then
        exercise_name="Challenge: Build NGINX Load Balancer with Container"
    
    elif [ "$2" == "challenge-troubleshoot" ];then
        exercise_name="Challenge: Solve Issues of HTTPD & Executable App Permissions"
    
    elif [ "$2" == "intro-git" ];then
        exercise_name="Intro to Git"
    
    elif [ "$2" == "challenge-git" ];then
        exercise_name="Challenge: Create systemd service from bash script that automatically synchronize to your github repo (auto pull & push) every 5 minutes"
    else
        exercise_name="Exercise Content Not Found !!"
    fi
    echo "$exercise_name" > /tmp/exercise






elif [ "$2" == "grade" ]
fi