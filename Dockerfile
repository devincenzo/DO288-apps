FROM websphere-liberty:19.0.0.5-kernel

ARG REPOSITORIES_PROPERTIES=""

RUN if [ ! -z $REPOSITORIES_PROPERTIES ]; then mkdir /opt/ibm/wlp/etc/ \
  && echo $REPOSITORIES_PROPERTIES > /opt/ibm/wlp/etc/repositories.properties; fi \
  && installUtility install --acceptLicense \
    appSecurity-2.0 bluemixUtility-1.0 collectiveMember-1.0 ldapRegistry-3.0 \
    localConnector-1.0 microProfile-1.0 microProfile-1.2 microProfile-1.3 microProfile-1.4 monitor-1.0 restConnector-1.0 \
    requestTiming-1.0 restConnector-2.0 sessionDatabase-1.0 sessionCache-1.0 ssl-1.0 transportSecurity-1.0 \
    webCache-1.0 webProfile-7.0 appSecurityClient-1.0 javaee-7.0 javaeeClient-7.0 jpa-2.0\
	jms-2.0 wmqJmsClient-2.0 ejbPersistentTimer-3.2 \
  && if [ ! -z $REPOSITORIES_PROPERTIES ]; then rm /opt/ibm/wlp/etc/repositories.properties; fi \
  && rm -rf /output/workarea /output/logs \
  && chmod -R g+rwx /opt/ibm/wlp/output/*

COPY --chown=1001:0 server.xml /config/

COPY jvm.options /config/


ADD WasteDeviceEAR.ear /opt/ibm/wlp/usr/servers/defaultServer/apps

RUN mkdir /opt/ibm/wlp/usr/servers/defaultServer/resources && mkdir /opt/ibm/wlp/usr/servers/defaultServer/resources/jmsLib && mkdir /opt/ibm/wlp/usr/servers/defaultServer/resources/oraclejdbc && \
    mkdir /opt/ibm/wlp/usr/servers/defaultServer/resources/properties && mkdir /opt/ibm/wlp/usr/servers/defaultServer/resources/properties/sviluppo && mkdir /opt/ibm/wlp/usr/servers/defaultServer/resources/lib && \
	mkdir /opt/ibm/wlp/usr/servers/defaultServer/BEAM && mkdir /opt/ibm/wlp/usr/servers/defaultServer/BEAM/logs 
	
	
ADD  ./oraclejdbc /opt/ibm/wlp/usr/servers/defaultServer/resources/oraclejdbc

ADD  ./jmsLib /opt/ibm/wlp/usr/servers/defaultServer/resources/jmsLib

ADD  ./lib /opt/ibm/wlp/usr/servers/defaultServer/resources/lib

ADD  ./properties /opt/ibm/wlp/usr/servers/defaultServer/resources/properties


#RUN chmod 777 /opt/ibm/wlp/usr/servers/defaultServer/BEAM/logs


RUN chgrp -R 0 /opt/ibm/wlp/usr/servers/defaultServer/BEAM && chmod -R g=u /opt/ibm/wlp/usr/servers/defaultServer/BEAM

USER 1001

#RUN server start && server stop && rm -rf /output/resources/security/ /output/messaging /logs/* $WLP_OUTPUT_DIR/.classCache && chmod -R g+rwx /opt/ibm/wlp/output/*
