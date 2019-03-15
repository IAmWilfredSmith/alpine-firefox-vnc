# alpine-firefox-vnc

This repository defines a Docker container based on Alpine that has all updates applied and exposes a local VNC server. The only applications exposed are a terminal and the Firefox browser.

The container can be pulled directly from the Docker Hub with the following command:

`docker pull wilfredsmith/alpine-firefox-vnc`

. When building the container, you can configure the OS version used, the administrative user and the virtual display geometry. For example,

`docker build --build-arg ADMIN_USERNAME=bubba --build-arg ADMIN_PASSWORD=gump .`

Arguments:																																							 
	  ADMIN_GROUP - group name for the OS administrotor (default is administrators)												      		 
	  ADMIN_PASSWORD - initial password for the OS administrator (default is insecure). Change this immediately!   					 
	  ADMIN_USERNAME - user name of the OS administrator (default is admin)																		    
     ALPINE_VERSION - specify the version of Alpine to use (default is latest).   																  
	  GEOMETRY - widthxheightxbpp for the virtual display to be exposed (default is 1920x1200x24)											 
	  VNC_LISTENPORT - TCP port on which the VNC server will listen. (default is 5901)															 

NOTA BENE: You should immediately change the password of the administrative user. The value of these arguments can be retrieved by viewing the history of the Docker image.

NOTA BENE 2: The VNC session exposed is "plain text."

To run the container and start a VNC session into it,

	1. docker run -p 5901:5901 wilfredsmith/alpine-firefox-vnc
	2. Start a VNC session to localhost:5901
	3. Right-click on the desktop and select Firefox from the menu

