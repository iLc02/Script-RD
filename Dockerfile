FROM ubuntu

MAINTAINER pmarx <pierreleroy476@gmail.com>

## Updating & installing
RUN apt-get update && apt-get -y install curl wget jq rename nano cron rsyslog

#Copying files
ADD Functions/ /script/Functions/
ADD Login_Syno.sh RealDebrid.sh /script/

#Make files executables
RUN chmod +x /script/RealDebrid.sh /script/Login_Syno.sh /script/Functions/AddMagnet.sh /script/Functions/AddTorrent.sh \
 /script/Functions/Cleanup.sh /script/Functions/Counting.sh /script/Functions/Download.sh /script/Functions/LinksFormatting.sh /script/Functions/TorrentFormatting.sh

# Variables
ENV TorrentsFolder /torrents
ENV RDtoken Token_from_RD
ENV RDMaxTorrents 20
ENV MaximumSpots 20
ENV Syno_IP Synology_IP
ENV Syno_User Synology_User
ENV Syno_Pass Synology_Password

#Exposing volumes
VOLUME /torrents

#Setting up cron
RUN mkdir /script/Logs
RUN touch /script/Logs/RealDebrid_log /script/Logs/Syno_log
RUN touch /root/env.txt

RUN service cron start
RUN touch /root/mycron
RUN echo "* * * * * /script/RealDebrid.sh > /script/Logs/RealDebrid_log" >> /root/script
RUN echo "* * 4 * * /script/Login_Syno.sh > /script/Logs/Syno_log" >> /root/script
RUN echo "# Empty line" >> /root/script

#Starting script once
#RUN bash /script/Login_Syno.sh > /script/Logs/Syno_log

CMD cron && env > /root/env && \
cat /root/env /root/script > /root/mycron && \
crontab /root/mycron && \
#rm /root/env /root/script /root/mycron && \
/script/Login_Syno.sh && \
tail -f /script/Logs/RealDebrid_log
