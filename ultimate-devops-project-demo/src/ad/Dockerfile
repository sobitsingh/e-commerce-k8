FROM eclipse-temurin:21-jdk AS build

WORKDIR /usr/src/app/

COPY gradlew* settings.gradle* build.gradle* ./
COPY ./gradle ./gradle
RUN chmod +x gradlew
RUN ./gradlew
RUN ./gradlew downloadRepos

COPY . .
COPY ./pb ./proto
RUN chmod +x gradlew
RUN ./gradlew installDist -PprotoSourceDir=./proto

FROM eclipse-temurin:21-jre as final

WORKDIR /usr/src/app/

COPY --from=build /usr/src/app/ ./

ENV AD_PORT=8080
ENV FEATURE_FLAG_GRPC_SERVICE_ADDR=featureflagservice:50053

CMD [ "./build/install/opentelemetry-demo-ad/bin/Ad" ]