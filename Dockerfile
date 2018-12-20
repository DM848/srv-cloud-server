FROM jolielang/jolie:latest


RUN apk update
RUN apk add git
RUN apk add bash
RUN apk add curl

#RUN git clone https://github.com/DM848/DM848-project.git

ADD cloud_server.ol .
ADD cloud_server.iol .
ADD jolie_deployer_interface.iol .
ADD alive.sh .

#WORKDIR DM848-project/src/embedding_jolie


CMD ["jolie", "cloud_server.ol"]
