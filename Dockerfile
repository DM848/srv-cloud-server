FROM dm848/cs-jolie:v1.3.1

RUN apk update
RUN apk add bash
RUN apk add curl
RUN apk add perl

WORKDIR /service
COPY . .
RUN mv start.sh /bin/start-srv

# add ContainerPilot configuration
ENV CONTAINERPILOT=/service/srv.json5

# Stop the container if we can't get a response from the health endpoint
HEALTHCHECK CMD curl --fail http://localhost:8000/health || exit 1

# k8s handles port exposure
CMD ["/bin/start-srv"]
