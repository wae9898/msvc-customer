FROM openjdk:17-jdk as builder

WORKDIR /app/msvc-customer

COPY ./pom.xml /app
COPY ./msvc-customer/.mvn ./.mvn
COPY ./msvc-customer/mvnw .
COPY ./msvc-customer/pom.xml .

RUN ./mvnw dependency:go-offline

COPY ./msvc-customer/src ./src

RUN ./mvnw clean package -DskipTests

FROM openjdk:17-jdk

WORKDIR /app
RUN mkdir ./logs
COPY --from=builder /app/msvc-customer/target/msvc-customer-0.0.1-SNAPSHOT.jar .
EXPOSE 8002

CMD ["java", "-jar", "msvc-customer-0.0.1-SNAPSHOT.jar"]