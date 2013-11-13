# Githug
#
# VERSION               0.1

FROM greglearns/ruby
# make sure the package repository is up to date
#
RUN apt-get update
RUN apt-get install -y openssh-server whois vim nano
RUN mkdir /var/run/sshd

RUN adduser --home /home/githug/git_hug --shell /bin/bash --disabled-login githug

RUN gem install githug

RUN cd /home/githug && echo "y" | githug
RUN chown githug:githug /home/githug/git_hug


RUN echo "#!/bin/bash" > /etc/motd.tail
RUN chmod +x /etc/motd.tail
RUN echo "\033[1;34m" > /etc/motd.tail
RUN echo "Welcome to Githug" >> /etc/motd.tail
RUN echo "Your instance will live for 15 minutes" >> /etc/motd.tail
RUN echo "Please run githug to begin" >> /etc/motd.tail
RUN echo "\033[0m" >> /etc/motd.tail

#Stop cacheing - totally not a hack
ADD . .

#GENERATE A PASSWORD
RUN export GITHUG_PASSWD=`tr -dc "[:alpha:]" < /dev/urandom | head -c 8`; export GITHUG_PASSWD_HASH=`mkpasswd $GITHUG_PASSWD`; usermod --password $GITHUG_PASSWD_HASH githug; echo "FINDME $GITHUG_PASSWD"

EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]
