ARG IMAGE=containers.intersystems.com/intersystems/iris:2020.3.0.221.0
# ARG IMAGE=containers.intersystems.com/intersystems/iris:2020.4.0.547.0
# ARG IMAGE=containers.intersystems.com/intersystems/iris:2021.1.0.215.0
FROM $IMAGE

USER root
# RUN apt-get update && apt-get install -y \
# 	nano \
#     arping \
# 	sudo && \
# 	/bin/echo -e ${ISC_PACKAGE_MGRUSER}\\tALL=\(ALL\)\\tNOPASSWD: ALL >> /etc/sudoers && \
# 	sudo -u ${ISC_PACKAGE_MGRUSER} sudo echo enabled passwordless sudo-ing for ${ISC_PACKAGE_MGRUSER}



# COPY session.sh /

RUN mkdir /opt/demo && \
    chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/demo

USER ${ISC_PACKAGE_MGRUSER}
WORKDIR /opt/demo
ARG IRIS_MIRROR_ROLE=master

COPY src /tmp/src

# SHELL [ "/session.sh" ]

# RUN \
# do $SYSTEM.OBJ.Load("Installer.cls", "ck") \
# set sc = ##class(Demo.Installer).setup()

RUN iris start IRIS \
	&& iris session IRIS < /tmp/src/iris.script && iris stop IRIS quietly

# COPY init_mirror.sh /tmp

ENTRYPOINT ["/iris-main"] 