FROM ubuntu:14.04

MAINTAINER mintplo <mintplo21@gmail.com>

# apache & ansible install
RUN apt-get update && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:ansible/ansible && \
	apt-get update && \
	apt-get install -y ansible && \
	apt-get install -y apache2 && \
	apt-get clean

# ansible configuration
RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts

ADD ansible /opt/ansible

WORKDIR /opt/ansible

RUN chmod +x ansible-build.sh

# ansible playbook run
RUN /bin/bash -c "/opt/ansible/ansible-build.sh"

# storage location changed from container to host
VOLUME ["/etc/apache2/", "/var/log/apache2/"]

# Apache Run in background
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

EXPOSE 80

# example:
# docker run -d -p 80:80 -v /var/www:/var/www --name=example-apache build_image
#
# bash shell entry example:
# docker exec -i -t apache /bin/bash
 