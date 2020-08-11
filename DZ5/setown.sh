#!/bin/bash

ls -la /opt/atlassian/jira

if [[ cat /etc/passwd|grep jira ]];then
chown -R jira:jira /opt/atlassian
fi
