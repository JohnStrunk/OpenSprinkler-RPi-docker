FROM multiarch/alpine:armhf-v3.5 as base-img



########################################
FROM base-img as build-img
RUN apk --no-cache add \
      bash \
      ca-certificates \
      g++ \
      unzip \
      wget
RUN wget https://github.com/OpenSprinkler/OpenSprinkler-Firmware/archive/master.zip && \
    unzip master.zip && \
    cd /OpenSprinkler-Firmware-master && \
    ./build.sh -s ospi



########################################
FROM base-img
RUN apk --no-cache add \
      libstdc++ \
    && \
    mkdir /OpenSprinkler && \
    mkdir -p /data/logs && \
    cd /OpenSprinkler && \
    ln -s /data/stns.dat && \
    ln -s /data/nvm.dat && \
    ln -s /data/logs
COPY --from=build-img /OpenSprinkler-Firmware-master/OpenSprinkler /OpenSprinkler/OpenSprinkler
WORKDIR /OpenSprinkler

#-- Logs and config information go into the volume on /data
VOLUME /data

#-- OpenSprinkler interface is available on 8080
EXPOSE 8080

CMD [ "./OpenSprinkler" ]
