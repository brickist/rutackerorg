FROM ubuntu:20.04


RUN apt update && apt-get -y install transmission-cli transmission-common transmission-daemon curlftpfs

RUN service transmission-daemon stop
RUN mkdir -p /etc/transmission-daemon/ && mkdir -p /etc/clooder
RUN sed -i 's/"rpc-whitelist": "127.0.0.1"/"rpc-whitelist": "*.*.*.*"/g' /etc/transmission-daemon/settings.json

RUN sed -i 's|"rpc-host-whitelist": ".*",|"rpc-host-whitelist": "rutackerorg-ag29yje5.b4a.run",|g' /etc/transmission-daemon/settings.json

RUN sed -i 's|"cache-size-mb": .*,|"cache-size-mb": 200,|g' /etc/transmission-daemon/settings.json
RUN sed -i 's|"download-dir": .*,|"download-dir": "/etc/clooder/cloodist",|g' /etc/transmission-daemon/settings.json

    
RUN echo '#!/bin/bash' > /etc/transmission-daemon/startup.sh && \
    echo 'curlftpfs -o ssl,direct_io ftp://ubzRjOLzGBmFko8k:3mDlXTJ9RrQAbliChyeWEsfH0Yoj7AR7UpAxltYr@ftp.tebi.io' >> /etc/transmission-daemon/startup.sh && \
    echo 'transmission-daemon -m -f -c /etc/clooder/cloodist/torrents -g /etc/transmission-daemon/ -u BricksConductor -v Riceinflates54@!' >> /etc/transmission-daemon/startup.sh
  
EXPOSE 3000 7000 42069/tcp 42069/udp 5489/tcp 5489/udp 9091 51413/tcp 51413/udp

CMD ["/bin/bash", "-c", "curlftpfs -o ssl,direct_io ftp://ubzRjOLzGBmFko8k:3mDlXTJ9RrQAbliChyeWEsfH0Yoj7AR7UpAxltYr@ftp.tebi.io /etc/clooder/cloodist/torrents;transmission-daemon -m -f -c /etc/clooder/cloodist/torrents -g /etc/transmission-daemon/ -u BricksConductor -v Riceinflates54@!"]
