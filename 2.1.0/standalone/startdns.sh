docker run -d --name dns-gen --publish 172.17.100.1:53:53/udp --volume /var/run/docker.sock:/var/run/docker.sock jderusse/dns-gen
