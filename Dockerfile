FROM curlimages/curl:latest AS download
ARG VERSION
# We use a non-trusted CA, so we have to fall back to curl instead of directly using 'ADD ...'
RUN curl -fk -o /tmp/app.jar https://colossus.kruemel.home/nexus/repository/webtools-maven/ch/guengel/webtools/nmapserviceproxy/${VERSION}/nmapserviceproxy-${VERSION}-jar-with-dependencies.jar

FROM openjdk:11-jre-slim

COPY --from=download /tmp/app.jar /
USER 424242

ENTRYPOINT ["/usr/local/openjdk-11/bin/java"]
CMD ["-jar", "/app.jar"]
