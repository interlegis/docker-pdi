FROM openjdk:8-jre-slim

MAINTAINER Matheus Garcia matheusg@interlegis.leg.br

# Init ENV
ENV PENTAHO_HOME /opt/pentaho

# Apply JAVA_HOME
RUN . /etc/environment
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

# Install Dependences
RUN apt-get update; apt-get install zip netcat -y; \
    apt-get install wget unzip git vim cron -y; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir ${PENTAHO_HOME}; useradd -s /bin/bash -d ${PENTAHO_HOME} pentaho; chown pentaho:pentaho ${PENTAHO_HOME}

#Diretório contendo as transformações
RUN mkdir /dados

VOLUME /etc/cron.d
VOLUME /dados

# Download Pentaho PDI 
RUN wget --progress=dot:giga https://downloads.sourceforge.net/project/pentaho/Pentaho%208.0/client-tools/pdi-ce-8.0.0.0-28.zip -O /tmp/pentaho-pdi.zip 

RUN /usr/bin/unzip -q /tmp/pentaho-pdi.zip -d  $PENTAHO_HOME; \
    rm -f /tmp/pentaho-pdi.zip; \
    chmod +x $PENTAHO_HOME/data-integration/*.sh

CMD ["/usr/sbin/cron"]
