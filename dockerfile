FROM intersystems/irishealth-ml-community:2021.1.0.215.0
COPY ./demo /tmp/iris
USER root
# RUN apt-get update && apt-get install -y \
# 	openjdk-11-jdk \
# 	nano \
# 	sudo && \
# 	/bin/echo -e ${ISC_PACKAGE_MGRUSER}\\tALL=\(ALL\)\\tNOPASSWD: ALL >> /etc/sudoers && \
# 	sudo -u ${ISC_PACKAGE_MGRUSER} sudo echo enabled passwordless sudo-ing for ${ISC_PACKAGE_MGRUSER}

# RUN export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
USER irisowner
RUN export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
RUN export PATH=$PATH:$JAVA_HOME/bin

RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris/iris.script && iris stop IRIS quietly

ENTRYPOINT ["/iris-main"] 