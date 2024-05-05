#!/bin/bash
student_data(){
    # Fill Student Data
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

send_data(){
    exercise=$(cat /tmp/exercise)
    mentor=$(cat /tmp/mentor)
    name=$(cat /tmp/name)
    email=$(cat /tmp/email)
    rhnid=$(cat /tmp/rhnid)  
    score=$(cat /tmp/score)
    status=$(cat /tmp/status)
    id="https://script.google.com/macros/s/AKfycbzjc0K-p4ODv1IW3CF3xLjmNYt80rOVM1C8U-664E1CWJaswzFoCJMSTYFiSJIedD2J_w/exec"
    curl -X POST \
    "$id" \
    -d "exercise=$exercise" \
    -d "mentor=$mentor" \
    -d "name=$name" \
    -d "email=$email" \
    -d "rhnid=$rhnid" \
    -d "total=$score" \
    -d "status=$status" &>/dev/null
}


lab_status(){
    echo -ne "\033[1mLAB Status: \033[0m"
    score=$(cat /tmp/score)
    if [ "$score" == "100" ];then
        pass
        echo "PASS" > /tmp/status
        send_data
    else
        fail
        echo "FAIL" > /tmp/status
    fi
}
pass(){
    printf "\033[0;32m PASS \033[0m\n" 
}

fail(){
    printf "\033[0;31m FAIL \033[0m\n"
}

grade_epel() {
    echo -ne "Installing EPEL Repository ....."
    dnf repolist all | grep enabled | grep epel | wc -l | grep 2 &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 50 ))
    else
        fail
    fi
    echo -ne "Installing Conda ....."
    conda -V &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 50 ))
    else
        fail
    fi
    echo -ne "\033[1mScore: \033[0m"
    echo $score
    echo "$score" > /tmp/score
    lab_status
    echo ""
}

grade_challenge-leapp(){
    echo -ne "Installing LEAPP ....."
    leapp --version &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 50 ))
    else
        fail
    fi
    echo -ne "Update The RHEL Version to RHEL9 ....."
    cat /etc/redhat-release | grep "Red Hat Enterprise Linux release 9" &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 50 ))
    else
        fail
    fi
    echo -ne "\033[1mScore: \033[0m"
    echo $score
    echo "$score" > /tmp/score
    lab_status
    echo ""
}

grade_run-container() {
    echo -ne "Installing Podman ....."
    podman -v &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Podman Service is Enabled ....."
    systemctl is-enabled podman | grep enabled &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Check the Container Image ....."
    podman images | grep docker.io/grafana/grafana | grep latest &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 20 ))
    else
        fail
    fi
    echo -ne "Run the Grafana as Container ....."
    podman ps -a | grep Grafana | grep Up &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 20 ))
    else
        fail
    fi
    echo -ne "Grafana is Running ....."
    curl http://localhost:3000 &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 40 ))
    else
        fail
    fi
    echo -ne "\033[1mScore: \033[0m"
    echo $score
    echo "$score" > /tmp/score
    lab_status
    echo ""
}

grade_build-container(){
    echo -ne "Check the UBI 9 Container Image ....."
    podman images | grep registry.access.redhat.com/ubi9/ubi | grep latest &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Check EPEL Repository Installed in Container Image ....."
    buildah run ubi-working-container -- rpm -q epel-release | grep el9 &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Check Moon-Buggy Installed in Container Image ....."
    buildah run ubi-working-container -- dnf info moon-buggy | grep Installed &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Check the Moon-Buggy Container Image Exist....."
    podman images | grep localhost/moon-buggy | grep latest &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Moon-Buggy Container Executed....."
    podman ps -a | grep localhost/moon-buggy &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Check the UBI 8 Container Image ....."
    podman images | grep registry.access.redhat.com/ubi8/ubi | grep latest &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Check httpd Installed in Container Image ....."
    buildah run ubi-working-container-1 -- dnf info httpd | grep Installed &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Check the Clumsy-Bird Container Image Exist....."
    podman images | grep localhost/clumsy-bird | grep latest &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Clumsy-Bird Container Executed....."
    curl http://localhost:8080 &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 20 ))
    else
        fail
    fi
    echo -ne "\033[1mScore: \033[0m"
    echo $score
    echo "$score" > /tmp/score
    lab_status
    echo ""
}

grade_challenge1-container() {
    echo -ne "Installing Podman ....."
    podman -v &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Podman Service is Enabled ....."
    systemctl is-enabled podman | grep enabled &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 10 ))
    else
        fail
    fi
    echo -ne "Check the Container Image ....."
    podman images | grep docker.io/grafana/grafana | grep latest &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 20 ))
    else
        fail
    fi
    echo -ne "Run the Grafana as Container ....."
    podman ps -a | grep Grafana | grep Up &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 20 ))
    else
        fail
    fi
    echo -ne "Grafana is Running ....."
    curl http://localhost:3000 &>/dev/null
    if [ $? -eq 0 ];then
        pass
        score=$(( score + 40 ))
    else
        fail
    fi
    echo -ne "\033[1mScore: \033[0m"
    echo $score
    echo "$score" > /tmp/score
    lab_status
    echo ""
}

if [ "$1" == "start" ] && [ ! -z "$2" ]; then
    student_data
    if [ "$2" == "epel" ]; then
        exercise_name="Extra Packages for Enterprise Linux (EPEL) for RHEL"

    elif [ "$2" == "challenge-leapp" ]; then
        exercise_name="Challenge: Upgrade to Red Hat Enterprise Linux 9 in place with LEAPP"
        
    elif [ "$2" == "run-container" ]; then
        exercise_name="Running containers on Red Hat Enterprise Linux"
        sudo dnf remove -y podman &>/dev/null

    elif [ "$2" == "build-container" ]; then
        exercise_name="Build an App Into Container Image"
    
    elif [ "$2" == "challenge1-container" ]; then
        exercise_name="Challenge: Build Simple Apache Website Using Your Own Containerfile and Push The Container Image To quay.io Registry"
        sudo dnf remove -y podman &>/dev/null
        
    elif [ "$2" == "challenge2-container" ]; then
        exercise_name="Challenge: Build NGINX Load Balancer with Container"
    
    elif [ "$2" == "challenge-troubleshoot" ]; then
        exercise_name="Challenge: Solve Issues of HTTPD & Executable App Permissions"
    
    elif [ "$2" == "intro-git" ]; then
        exercise_name="Intro to Git"
    
    elif [ "$2" == "challenge-git" ]; then
        exercise_name="Challenge: Create systemd service from bash script that automatically synchronize to your github repo (auto pull & push) every 5 minutes"
    else
        echo "Exercise Content Not Found !!"
    fi
    echo "$2" > /tmp/exercise
    echo -e "\033[1mLAB Exercise: $exercise_name\033[0m"
    echo -e "\e[1;42;97mLAB STARTED, Good Luck !!\e[0m"
    echo ""
    
elif [ "$1" == "grade" ] && [ ! -z "$2" ]; then
    if [ "$2" == "epel" ]; then
        grade_epel
    elif [ "$2" == "challenge-leapp" ]; then
        grade_challenge-leapp
    elif [ "$2" == "run-container" ]; then
        grade_run-container
    elif [ "$2" == "build-container" ]; then
        grade_build-container
    elif [ "$2" == "challenge1-container" ]; then
        grade_challenge1-container
    fi
fi
