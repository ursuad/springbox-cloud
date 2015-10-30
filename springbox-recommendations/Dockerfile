FROM ursuad/docker-java8
VOLUME /tmp
ADD target/springbox-recommendations-0.0.1-SNAPSHOT.jar /app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]