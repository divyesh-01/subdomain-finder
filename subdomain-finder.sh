#!/bin/sh
clear
echo "\nenter the domain name "
read domain
echo  "enter where you want to save 'example ans.txt'"
read file

echo "assetfinder is running \n "
assetfinder --subs-only $domain | sort -u >> assetfinder.txt

echo "subfinder is running \n "
subfinder -d $domain -silent >> subfinder.txt

echo "amass is running \n " 
amass enum -silent -passive -d  $domain -o amass.txt

# specify your token below and remove this "<>"
echo "finding from github \n " 
github-subdomains.py -t <your github token> -d $domain >> github.txt



echo "finding from jldc \n "
curl -s "https://jldc.me/anubis/subdomains/$domain" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" >>  jldc.txt


#subdomains through crt.sh

echo "finding from crt api \n "
curl  -s "https://crt.sh/?q=$domain&output=json" >>  crt.json
cat crt.json | jq -r '.[] |  .name_value' | uniq >> file.txt

cat amass.txt assetfinder.txt file.txt github.txt jldc.txt subfinder.txt | anew >> $file
rm amass.txt assetfinder.txt file.txt github.txt jldc.txt subfinder.txt crt.json

echo "file saved to $file"
