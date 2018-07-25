#/bin/env bash

date_time=`date +%Y%m%d\-%H%M%S`
git_branch=`echo ${GIT_BRANCH} |awk -F '/' '{print $2}'`
git_commit=${GIT_COMMIT:0:8}
echo "${git_commit}">version.txt
tar -zcf $WORKSPACE/lovejob-${git_branch}-${git_commit}-${date_time}.tar.gz *

GIT_USER=`git log --pretty=format:'%an' -1`
GIT_EMAIL=`git log --pretty=format:'%ae' -1`
echo $GIT_USER
echo $GIT_EMAIL
if [ -f profile.txt ]
then
    rm -f profile.txt
fi
echo "GIT_USER=$GIT_USER">profile.txt
echo "GIT_EMAIL=$GIT_EMAIL">>profile.txt
