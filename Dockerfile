# Test image for Phusion Baseimage

FROM phusion/baseimage:latest

MAINTAINER Misaka

COPY etc/ /etc/

COPY usr/ /usr/

RUN chmod u+x /etc/service/**/run /usr/bin/loop.sh
