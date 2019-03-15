####################################################################################################################################
#                                                                                                                                  #
# Dockerfile - Docker container definition for wilfredsmith/alpine-firefox-vnc                                        [Dockerfile] #
#                                                                                                                                  #
# Copyright (c) 2014-2019, Wilfred A. Smith. All rights reserved.                                                                  #
#                                                                                                                                  #
# Arguments:                                                                                                                       #
#                                                                                                                                  #
#     ADMIN_GROUP - group name for the OS administrotor (default is administrators)                                                #
#     ADMIN_PASSWORD - initial password for the OS administrator (default is insecure). Change this immediately!                   #
#     ADMIN_USERNAME - user name of the OS administrator (default is admin)                                                        #
#     ALPINE_VERSION - specify the version of Alpine to use (default is latest).                                                   #
#     GEOMETRY - widthxheightxbpp for the virtual display to be exposed (default is 1920x1200x24)                                  #
#     VNC_LISTENPORT - TCP port on which the VNC server will listen. (default is 5901)                                             #
#                                                                                                                                  #
####################################################################################################################################

ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
ARG ALPINE_VERSION
LABEL maintainer="Wilfred Smith"
ARG ADMIN_USERNAME=admin
ARG ADMIN_GROUP=administrators
ARG ADMIN_PASSWORD=insecure
ARG GEOMETRY=1920x1200x24
ARG VNC_LISTENPORT=5901

RUN echo "Building alpine-firefox-vnc with Alpine $ALPINE_VERSION" && \
    echo "User: $ADMIN_GROUP:$ADMIN_USERNAME will have initial password $ADMIN_PASSWORD" && \
    echo "The display will be configured for $GEOMETRY and the VNC server will listen on TCP port $VNC_LISTENPORT"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk update && \
    apk upgrade && \
    apk add --no-cache openbox sudo supervisor x11vnc xfce4-terminal xvfb dbus firefox openssh-client

RUN addgroup $ADMIN_GROUP
RUN adduser -G $ADMIN_GROUP -D -s /bin/sh $ADMIN_USERNAME
RUN echo "$ADMIN_USERNAME:$ADMIN_PASSWORD" | /usr/sbin/chpasswd
RUN echo "$ADMIN_USERNAME   ALL=(ALL) ALL" >> /etc/sudoers

RUN echo "[supervisord]" > /etc/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisord.conf && \
    echo >> /etc/supervisord.conf && \
    echo "[program:Xvfb]" >> /etc/supervisord.conf && \
    echo "command=/usr/bin/Xvfb :0 -screen 0 $GEOMETRY" >> /etc/supervisord.conf && \
    echo "autorestart=true" >> /etc/supervisord.conf && \
    echo "priority=500" >> /etc/supervisord.conf && \
    echo "user=$ADMIN_USERNAME" >> /etc/supervisord.conf && \
    echo >> /etc/supervisord.conf && \
    echo "[program:x11vnc]" >> /etc/supervisord.conf && \
    echo "command=/usr/bin/x11vnc -display :0 -6 -xkb -rfbport $VNC_LISTENPORT -wait 20 -nap -noxrecord -nopw -noxfixes -noxdamage" >> /etc/supervisord.conf && \
    echo "autorestart=true" >> /etc/supervisord.conf && \
    echo "priority=501" >> /etc/supervisord.conf && \
    echo "user=$ADMIN_USERNAME" >> /etc/supervisord.conf && \
    echo >> /etc/supervisord.conf && \
    echo "[program:openbox]" >> /etc/supervisord.conf && \
    echo "environment=DISPLAY=\":0\",HOME=\"/home/$ADMIN_USERNAME\",USER=\"$ADMIN_USERNAME\"" >> /etc/supervisord.conf && \
    echo "command=/usr/bin/openbox" >> /etc/supervisord.conf && \
    echo "autorestart=true" >> /etc/supervisord.conf && \
    echo "priority=503" >> /etc/supervisord.conf && \
    echo "user=$ADMIN_USERNAME" >> /etc/supervisord.conf && \
    echo >> /etc/supervisord.conf

RUN chmod 755 /etc/supervisord.conf

RUN echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > /etc/xdg/openbox/menu.xml && \
    echo "<openbox_menu>" >> /etc/xdg/openbox/menu.xml && \
    echo "   <menu id=\"root-menu\" label=\"Applications\">" >> /etc/xdg/openbox/menu.xml && \
    echo "      <item label=\"Firefox\">" >> /etc/xdg/openbox/menu.xml && \
    echo "         <action name=\"Execute\">" >> /etc/xdg/openbox/menu.xml && \
    echo "            <command>/usr/bin/firefox</command>" >> /etc/xdg/openbox/menu.xml && \
    echo "         </action>" >> /etc/xdg/openbox/menu.xml && \
    echo "      </item>" >> /etc/xdg/openbox/menu.xml && \
    echo "      <item label=\"Terminal\">" >> /etc/xdg/openbox/menu.xml && \
    echo "         <action name=\"Execute\">" >> /etc/xdg/openbox/menu.xml && \
    echo "            <command>/usr/bin/xfce4-terminal</command>" >> /etc/xdg/openbox/menu.xml && \
    echo "         </action>" >> /etc/xdg/openbox/menu.xml && \
    echo "      </item>" >> /etc/xdg/openbox/menu.xml && \
    echo "      <separator />" >> /etc/xdg/openbox/menu.xml && \
    echo "      <item label=\"Exit session\">" >> /etc/xdg/openbox/menu.xml && \
    echo "         <action name=\"Exit\">" >> /etc/xdg/openbox/menu.xml && \
    echo "            <prompt>yes</prompt>" >> /etc/xdg/openbox/menu.xml && \
    echo "         </action>" >> /etc/xdg/openbox/menu.xml && \
    echo "      </item>" >> /etc/xdg/openbox/menu.xml && \
    echo "   </menu>" >> /etc/xdg/openbox/menu.xml && \
    echo "</openbox_menu>" >> /etc/xdg/openbox/menu.xml

CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisord.conf"]
EXPOSE $VNC_LISTENPORT
USER $ADMIN_USERNAME
WORKDIR /home/$ADMIN_USERNAME
