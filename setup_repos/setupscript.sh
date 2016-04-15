#!/bin/bash
#source /opt/ros/hydro/setup.bash
#source ../../../devel/setup.bash
source ~/.bashrc
echo "Installing git repos"

if ! [ "$(basename $(cd ../..; pwd))" == "src" ]; then
	echo "Error: running in wrong directory">&2
	exit
fi

getBranch() {
    echo $(cd "$1"; git branch -vv | grep -oPm 1 '(?<=^\*\s)\w+' )
}

getRemote() {
    echo $(cd "$1"; git branch -vv | grep -oPm 1 '(?<=\[)[^/]+' )
}

getUrl() {
    echo $(cd "$1"; git remote show "$2" | grep -oPm 1 '(?<=Fetch URL: )(\/(?!$)|[^./]|\.(?!git$))*(?=.*$)' ) 
}

set -f; IFS=$'\n'
urls=($(cat <repo_urls.txt))
set +f; unset IFS

for myurl in "${urls[@]}"; do
    parts=($(echo "$myurl"))
    urln=${parts[0]}; remoten=${parts[1]}; branchn=${parts[2]}
    foldern=$(echo "$myurl" | grep -oP '(?<=\/)[^\s\/]*(?=\s)')
    #echo "$branchn $foldern $remoten $urln"
    if [ -d "../../$foldern" ]; then
    	echo "repo $foldern exists"
    	#myremote="$(getRemote "../../$foldern")"
    	#echo "$myremote" 
    	#if [ "$(getUrl "../../$foldern" "$myremote")" != "$urln" ]; then
    	#	echo "different sources!"
    	#	
    	#	( cd "../../$foldern"
    	#		git remote add gazeboremote "$urln"
    	#		git fetch gazeboremote
    	#		git stash
    	#		git checkout -t gazeboremote/"$branchn"
		#
    	#	)
    	#fi
    	#if [ "$(getBranch "../../$foldern")" != "$branchn" ]; then
    	#	echo "different branches!"
    	#fi
   	else
   		(cd ../../; git clone -b "$branchn" "$urln")
   	fi

done

more_packs=(pr2-gazebo moveit-ros-planning-interface moveit-full moveit-pr2 controller-manager gazebo-ros-control)
for pack in ${more_packs[@]}; do
    sudo apt-get install ros-hydro-"$pack" -y
done


(cd ../../; rosdep install --from-paths ./ --ignore-src --rosdistro=hydro -y)

source /opt/ros/hydro/setup.bash #not sure why it made me re-source here but okay whatever

(   
    dir=$(pwd)
    cd ./sensor*
    backup=$(pwd)
    roscd pr2_moveit_config/launch
    if ! [ -e "$backup/sensor_manager.launch.xml" ]; then #If no backup
        echo "Making backup"
        cp sensor_manager.launch.xml "$backup" #Make backup
    else
        echo "Keeping existing backup"
    fi
    rm sensor_manager.launch.xml
    cp "$dir/sensor_manager.launch.xml" ./ #Move modified one in
)


