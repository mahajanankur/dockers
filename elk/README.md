Once docker-compose up is running in one terminal, open another terminal to get inside the elasticsearch container by running the command:

> docker exec -it es01 bash

Then run the following command to generate passwords for all the built-in users:

> bin/elasticsearch-setup-passwords auto

Note them down and keep them somewhere safe and exit the container by Ctrl+D

Open http://localhost:5601 you will see the Kibana console but now it will ask for username and password.

Username: elastic

Password: Get from above command.

##Logstash

> docker run --rm -it -v ~/pipeline/:/usr/share/logstash/pipeline/ logstash:7.8.0
