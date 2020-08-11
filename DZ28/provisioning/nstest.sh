#!/bin/bash

set -x

dig -x 192.168.50.11 +short
dig web1.dns.lab +short
dig web2.dns.lab +short
dig www.newdns.lab +short

dig -x 192.168.50.11 +short @192.168.50.11
dig web1.dns.lab +short @192.168.50.11
dig web2.dns.lab +short @192.168.50.11
dig www.newdns.lab +short @192.168.50.11


