ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2021.1.0.215.0
# ARG IMAGE=containers.intersystems.com/intersystems/iris-ml-community:2021.1.0.215.0
# ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:2021.1.0.215.0
# ARG IMAGE=containers.intersystems.com/intersystems/irishealth-ml-community:2021.1.0.215.0
FROM $IMAGE
COPY ./demo /tmp/iris
COPY ./jdbc/postgresql-42.2.23.jar /opt/postgresql-42.2.23.jar
USER irisowner
RUN export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
RUN export PATH=$PATH:$JAVA_HOME/bin

RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris/iris.script && iris stop IRIS quietly

ENTRYPOINT ["/iris-main"] 