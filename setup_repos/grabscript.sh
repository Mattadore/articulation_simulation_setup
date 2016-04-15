#!/bin/bash

if [ "$(basename $(cd ~; pwd))" != "matt" ]; then
	echo "Warning: This will overwrite the current repository configuration">&2
	exit
fi

getBranch() {
    echo $(cd "$1"; git branch -vv | grep -oPm 1 '(?<=^\*\s)\w+' )
}

getRemote() {
    echo $(cd "$1"; git branch -vv | grep -oPm 1 '(?<=\[)[^/]+' )
}

getUrl() {
    echo $(cd "$1"; git remote show origin | grep -oPm 1 '(?<=Fetch URL: )(\/(?!$)|[^./]|\.(?!git$))*(?=.*$)' ) 
}

filenames=( $(for dir in ../../*/; do
    echo "$(getUrl "$dir") $(getRemote "$dir") $(getBranch "$dir")"
done) )

printf "%s %s %s\n" "${filenames[@]}" > repo_urls.txt

