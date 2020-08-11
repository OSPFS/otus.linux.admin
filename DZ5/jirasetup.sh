#!/usr/bin/expect

spawn ./atlassian-jira-software-8.5.1-x64.bin
expect "OK "
send "o\r"

expect "existing JIRA installation"
send "1\r"
expect "application-data"
send "\r"
expect "Install"
send "i\r"
sleep 35
send "n\r"

