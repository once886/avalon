FROM ubuntu
  
MAINTAINER 10086
  
# update source
RUN apt-get update
  
# Install curl
RUN apt-get -y install curl
  
# Install JDK 7  
RUN cd /tmp && curl -L 'http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie; gpw_e24=Dockerfile' | tar -xz
RUN mkdir -p /usr/lib/jvm
RUN mv /tmp/jdk1.8.0_172/ /usr/lib/jvm/jdk1.8.0_172/
  
# Set Oracle JDK 8 as default Java  
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_172/bin/java 300
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_172/bin/javac 300
  
ENV JAVA_HOME /usr/lib/jvm/jdk1.8.0_172/  
  
# Install tomcat8  
RUN cd /tmp && curl -L 'http://apache.communilink.net/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz' | tar -xz
RUN mv /tmp/apache-tomcat-8.5.32/ /opt/tomcat8/
  
ENV CATALINA_HOME /opt/tomcat8
ENV PATH $PATH:$CATALINA_HOME/bin
  
ADD tomcat8.sh /etc/init.d/tomcat8
RUN chmod 755 /etc/init.d/tomcat8

COPY firstweb.war /opt/tomcat8/webapps

# Expose ports.
EXPOSE 8080
  
# Define default command.
ENTRYPOINT service tomcat8 start && tail -f /opt/tomcat8/logs/catalina.out