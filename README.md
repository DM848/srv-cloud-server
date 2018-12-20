# README
Basically just the code example made by Jacopo, with some small changes.
* cloud_server: The main server script, a client can contact this with a jolie program to embed.
* client: An example client contacting the cloud_server and embedding the program briliantPrint.
* the file notes.md and install_script are just what could be used in order to install jolie on a clean VM.

## Try it out
* Run cloud_server.ol
* Run client.ol
* When embedding briliantPrint.ol, try it out by doing http request to <ip>:8080/currentTime
