FROM maven:3.9-eclipse-temurin-21

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn -B -DskipTests package

EXPOSE 8080

CMD ["mvn", "-B", "exec:java", "-Dexec.mainClass=com.college.server.EmbeddedTomcatServer"]
