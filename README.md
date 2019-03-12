# alpine-firefox-vnc
Fully updated Alpine with Firefox over VNC

If you want to run a browser (particularly Firefox) about as sandboxed as it can be and with minimal resources, install Docker, grab this container and connect to it with your favorite VNC client.

`docker run -p 5901:5901 wilfredsmith/alpine-firefox-vnc`

Then connect a VNC client to localhost:5901

Just remember that when you stop the container, all is forgotten.

You can still map in persistent storage if you'd like, or use SCP to grab a file that you want to hang on to.

Otherwise, it's like Vegas. What you do in your browser container stays in your browser container. Please just try not to do anything illegal!
