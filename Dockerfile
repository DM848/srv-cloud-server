FROM dm848/cs-jolie:v3.1.0

RUN apk update
RUN apk add bash
RUN apk add curl

# copy everything over
COPY . .

# Stop the container if we can't get a response from the health endpoint
HEALTHCHECK CMD curl --fail http://localhost:8000/health || exit 1

# open port 8000 & start program
EXPOSE 8000:8000
CMD ["jolie", "main.ol"]
