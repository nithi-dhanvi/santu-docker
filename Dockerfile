FROM openjdk:8
COPY target/springboot-maven-course-micro-svc-0.0.2-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
