# FROM docker.iscinternal.com/intersystems/webgateway:2020.3.0-latest
FROM containers.intersystems.com/intersystems/webgateway:2021.1.0.215.0

COPY entrypoint.sh /
RUN chmod a+x /entrypoint.sh
ENTRYPOINT  ["/entrypoint.sh"]