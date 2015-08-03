# Image contains:
# * Opscenter 5.2.0

FROM phusion/baseimage:latest

MAINTAINER Misaka

COPY etc/ /etc/

COPY usr/ /usr/

RUN chmod u+x /etc/service/**/run /usr/bin/loop.sh
