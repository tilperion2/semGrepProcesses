FROM ubuntu:21.04

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates fontconfig locales traceroute telnet net-tools unzip mc \
            python3.9 python3-pip python3-setuptools\
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1\
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#==================INSTALL JAVA SECTION==================
ENV JAVA_URL=https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11+9_openj9-0.26.0/OpenJDK11U-jdk_x64_linux_openj9_11.0.11_9_openj9-0.26.0.tar.gz
ENV JAVA_HASH=a605ab06f76533d44ce0828bd96836cc9c0e71ec3df3f8672052ea98dcbcca22

RUN set -eux; \
    ESUM="$JAVA_HASH"; \
    BINARY_URL="$JAVA_URL"; \
    curl -LSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;
ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"
#=================================================

#==================PYTHON SECTION==================
#Problem starts from SEmGRep v0.66.0 and further to the latest 0.72.0
RUN python3.9 -m pip install semgrep==0.66.0
RUN mkdir -p /tools/SemgrepRules

ADD semgrep/r2c-security-audit.yml /tools/SemgrepRules/
ADD /semgrep/testSources /tools/testSources
#==================================================

EXPOSE 8080:8080

# The application's jar file
ARG JAR_FILE=./build/libs/semGrepDemo-0.0.1-SNAPSHOT.jar

# Add the application's jar to the container
ADD ${JAR_FILE} semGrepDemo.jar

#semgrep --config='/tools/SemgrepRules/r2c-security-audit.yml' /tools/testSources --timeout 1800 --json -q --no-rewrite-rule-ids --max-lines-per-finding 8

# Run Java app the jar file - semGrep produces zombie/defunct processes only then.
ENTRYPOINT ["java","-jar","/semGrepDemo.jar"]
# If to use just empty placholder command - semGrep works just fine.
#CMD tail -f /dev/null