#!/bin/bash
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'


echo -e "Welcome to SearchUnify ELK Installer"

function info()
{
	if [ "$2" == "sameline" ];then 
		echo -ne "${LIGHTGREEN}${1}${NOCOLOR}\r"
	else 
		echo -e ${LIGHTGREEN}${1}${NOCOLOR} 
	fi
}

function ok()
{
	if [ "$2" == "sameline" ];then 
		echo -ne "${GREEN}${1}${NOCOLOR}\r"
	else 
		echo -e ${GREEN}${1}${NOCOLOR} 
	fi
}
function warn()
{
	if [ "$2" == "sameline" ];then 
		echo -ne "${YELLOW}${1}${NOCOLOR}\r"
	else 
		echo -e ${YELLOW}${1}${NOCOLOR} 
	fi
}
function fail()
{
	if [ "$2" == "sameline" ];then 
		echo -ne "${RED}${1}${NOCOLOR}\r"
	else 
		echo -e ${RED}${1}${NOCOLOR} 
	fi
}
if [ -z $1 ];then
    fail "Usage $0 <single-node|multi-node>"
    fail "Example: sh $0 single-node"
    exit;
fi

if [ "$1" == 'single-node' ];then
    COMPOSE_FILE="docker-compose-singlenode.yml"
    cat << "EOF" > instances.yml 
instances:
  - name: syslog01
    dns:
      - syslog01 
      - localhost
    ip:
      - 127.0.0.1
  - name: es01
    dns:
      - es01
      - localhost
    ip:
      - 127.0.0.1
  - name: 'kib01'
    dns:
      - kib01
      - localhost
EOF
elif [ "$1" == 'multi-node' ];then 
    COMPOSE_FILE="docker-compose-multinode.yml"
cat << "EOF" > instances.yml 
instances:
  - name: syslog01
    dns:
      - syslog01 
      - localhost
    ip:
      - 127.0.0.1     
  - name: es01
    dns:
      - es01
      - localhost
    ip:
      - 127.0.0.1
  - name: es02
    dns:
      - es02
      - localhost
    ip:
      - 127.0.0.1
  - name: es03
    dns:
      - es03
      - localhost
    ip:
      - 127.0.0.1
  - name: 'kib01'
    dns:
      - kib01
      - localhost
EOF

else
    fail "Invalid Option, Aborting..."
    exit 255
fi

info "Creating Certificates for the cluster..."
docker-compose -f create-certs.yml run --rm create_certs
info "Certificates Created, Now Creating Instances for ELK Stack"

docker-compose -f ${COMPOSE_FILE} up -d 
info "Waiting for Elasticsearch to be ready..."
SECONDS=0
while true; do 
	sleep 10
	warn " Still waiting for Elasticsearch to be ready , $SECONDS seconds elapsed" "sameline"
	curl -s -k  https://localhost:9200/_security/_authenticate?pretty | grep -i '"status" : 401' &>> /dev/null
	if [ $? -eq 0 ];then
		echo ""
		ok "Elasticsearch is now ready, moving to setup password !"
		break
	fi 
done 

docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords auto --batch --url https://es01:9200" > /tmp/creds.txt
if [ $? -ne 0 ];then
   fail "Couldn't Set Passwords, Aborting..."
   exit 255
fi
KIBANA_USER=`grep KIBANA_USER .env | awk -F'=' {'print $2'}`
kibana_password=`grep -i "${KIBANA_USER} =" /tmp/creds.txt | awk {'print $4'}`
elastic_password=`grep "PASSWORD elastic =" /tmp/creds.txt | awk {'print $4'}`
mv /tmp/creds.txt .creds.txt
sed -i "s/^ELASTICSEARCH_USERNAME=.*/ELASTICSEARCH_USERNAME=${KIBANA_USER}/" .env 
sed -i "s/^ELASTICSEARCH_PASSWORD=.*/ELASTICSEARCH_PASSWORD=${kibana_password}/" .env 
docker-compose -f ${COMPOSE_FILE} up -d
SECONDS=0
ok "Waiting for Elasticsearch to be ready"
while true; do 
	sleep 10
	warn " Still waiting for Elasticsearch to be ready, $SECONDS seconds elapsed" "sameline"
	curl -s -k  https://localhost:9200/_security/_authenticate?pretty | grep -i '"status" : 401' &>> /dev/null
	if [ $? -eq 0 ];then
		echo ""
		ok "Elasticsearch is now ready !"
		break
	fi 
done 

info "Everything should have been completed, please login to https://ipaddress:5601 with following user:"
info "--------------------------------------------------"
ok "Username: elastic"
ok "Password: ${elastic_password}"
info "--------------------------------------------------"
info "The initial set of credentials are stored in .creds.txt in the current Directory"
