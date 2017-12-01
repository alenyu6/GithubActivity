# Pull base image.
FROM tomcat

COPY activity2.war /usr/local/tomcat/webapps
ENV PATH=$PATH:/usr/local/tomcat/bin:
CMD catalina.sh run
