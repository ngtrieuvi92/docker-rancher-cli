# Download image
FROM alpine
MAINTAINER Vi Nguyen <vi.nt@geekup.vn>

# Make and set workdir
RUN mkdir /scripts
WORKDIR /scripts

# Install bash shell
RUN apk add --update bash && rm -rf /var/cache/apk/*

# Add rancher config file and script to run
ADD ./rancher /bin/rancher
ADD ./entrypoint.sh /bin/entrypoint.sh
ADD ./run.sh /scripts/run.sh
ADD ./run-migration.sh /scripts/run-migration.sh

# Add execute permission to scripts
RUN chmod +x /bin/entrypoint.sh
RUN chmod +x /scripts/run.sh
RUN chmod +x /scripts/run-migration.sh

# Volumne
# Add config volume
VOLUME /root/.rancher

CMD ["rancher"]
