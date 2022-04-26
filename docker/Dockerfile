FROM curlimages/curl:latest AS download
ARG VERSION
ARG REPOSITORY_USER
ARG REPOSITORY_PASSWORD
RUN curl -Lf -u "${REPOSITORY_USER}:${REPOSITORY_PASSWORD}"  -o /tmp/app.jar https://rafaelostertag.jfrog.io/artifactory/maven/ch/guengel/webtools/nmapserviceproxy/${VERSION}/nmapserviceproxy-${VERSION}-jar-with-dependencies.jar

FROM openjdk:11-jre-slim

COPY --from=download /tmp/app.jar /
USER 424242

ENTRYPOINT ["/usr/local/openjdk-11/bin/java"]
CMD ["-jar", "/app.jar"]
