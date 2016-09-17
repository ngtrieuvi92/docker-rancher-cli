# Download image
FROM alpine
MAINTAINER Vi Nguyen <vi.nt@geekup.vn>

# Install bash shell
RUN apk add --update bash && rm -rf /var/cache/apk/*

# Add rancher config file and script to run
ADD ./rancher /bin/rancher
ADD ./entrypoint.sh /bin/entrypoint.sh
ADD ./run.sh /bin/run.sh

# Add execute permission to scripts
RUN chmod +x /bin/entrypoint.sh
RUN chmod +x /bin/run.sh

# Volumne
# Add config volume
VOLUME /root/.rancher

# Make and set workdir
RUN mkdir /data
WORKDIR /data

CMD ["/bin/run.sh"]
