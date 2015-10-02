#! /bin/bash
#A script to set dynamic dns through NameCheap
#Written by Jeff Kaminski
#@archdukeofdoge
#https://github.com/thearchdukeofdoge
#
#Declare your variables################################
#Define your api key (password)
api_key=<get_your_own_api_key>
#
#Your domain name
domain_name=example.com
#
#Define the records you want updated here
declare -a records
records=(%40 www) #The %40 is a url encoded @ symbol
######################################################

#Function to send the new ipaddress to Namecheap
function update_ip {
	for record in `echo ${records[*]}`;
	do
	#q for quiet, spider for no download
	wget -q --spider https://dynamicdns.park-your-domain.com/update\?host\=$record\&domain\=$domain_name\&password\=$api_key\&ip\=$new_ip
	#Wait a polite amount of time between record updates
	sleep 10
	done
}

#New ip address, finds your current external ip address
new_ip=$(curl -s httpbin.org/ip | grep -i origin | sed 's/  \"origin\"\: \"//' | sed 's/\"//')

#Current dns record
current_dns=$(dig $domain_name +short)

#Does the domain need to be updated?
if [ new_ip != current_dns ]
    then
    update_ip
    else
    exit #nothing to do
fi

