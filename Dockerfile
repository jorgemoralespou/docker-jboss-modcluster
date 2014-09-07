############################################################
# Dockerfile to build container image of:
#   - Apache HTTP server
#   - Mod_cluster
# Based on Fedora
############################################################

# Set the base image to Fedora
FROM fedora

# File Author / Maintainer
MAINTAINER jmorales "jmorales@redhat.com"

####### Install software in one step ####################
RUN yum install -y httpd mod_cluster; yum clean all

####### Configure mod_cluster ##############
RUN sed -i -e 's/LoadModule proxy_balancer_module/#LoadModule proxy_balancer_module/g' /etc/httpd/conf.modules.d/00-proxy.conf

RUN sed -i '1,4d' /etc/httpd/conf.d/mod_cluster.conf
RUN tr -d '#' < /etc/httpd/conf.d/mod_cluster.conf > /etc/httpd/conf.d/mod_cluster.conf.new
RUN sed -i -e 's/Require host 127.0.0.1/Require all granted/g' /etc/httpd/conf.d/mod_cluster.conf.new
RUN echo 'ServerAdvertise On' >> /etc/httpd/conf.d/mod_cluster.conf.new
RUN rm /etc/httpd/conf.d/mod_cluster.conf
RUN mv /etc/httpd/conf.d/mod_cluster.conf.new /etc/httpd/conf.d/mod_cluster.conf

####### OPEN PORTS ###############
EXPOSE 80

####### Just run
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
