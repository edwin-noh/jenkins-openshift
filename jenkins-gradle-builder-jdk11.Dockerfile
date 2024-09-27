FROM registry.access.redhat.com/ubi8/ubi:8.10 AS builder

RUN dnf install -y unzip && \
    dnf clean all

# Gradle
ARG GRADLE_VERSION=7.6
RUN curl -L "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o /tmp/gradle-bin.zip && \
    unzip -q /tmp/gradle-bin.zip -d /opt/gradle-bin && \
    mv /opt/gradle-bin/gradle-${GRADLE_VERSION} /opt/gradle

ENV GRADLE_HOME=/opt/gradle
ENV PATH="${PATH}:${GRADLE_HOME}/bin"

#Sonar Scanner
ARG SONAR_VERSION=5.0.1.3006
ARG SONAR_SCANNER_HOME=/opt/sonar-scanner
RUN curl -L "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_VERSION}-linux.zip" -o /tmp/sonar-cli.zip && \
    unzip -q /tmp/sonar-cli.zip -d ${SONAR_SCANNER_HOME} && \
    mv ${SONAR_SCANNER_HOME}/*${SONAR_VERSION}*/* ${SONAR_SCANNER_HOME}

#Runnable
# FROM registry.redhat.io/ocp-tools-4/jenkins-agent-base-rhel8:v4.15.0
FROM registry.redhat.io/ubi8/openjdk-17:1.20

USER root

COPY --from=builder /opt/gradle /opt/gradle
RUN chown -R 1001:0 /opt/gradle && \
    chmod -R g+rw /opt/gradle

COPY --from=builder /opt/sonar-scanner /opt/sonar-scanner
RUN chown -R 1001:0 /opt/sonar-scanner && \
    chmod -R g+rw /opt/sonar-scanner

ENV GRADLE_HOME=/opt/gradle
ENV PATH="${PATH}:${GRADLE_HOME}/bin"

ENV SONAR_HOME=/opt/sonar-scanner
ENV PATH="${PATH}:${SONAR_HOME}/bin"

USER 1001

RUN gradle --version -g ~/.gradle && \
    sonar-scanner --version
# Runnable
# FROM registry.access.redhat.com/ubi9/openjdk-17-runtime:1.20

# LABEL name="lotte-members/jenkins-ubi9-build" \
#       io.k8s.display-name="Jenkins Agent java build"

# USER root

# COPY --from=builder /opt/gradle /opt/gradle
# RUN chown -R 1001:0 /opt/gradle && \
#     chmod -R g+rw /opt/gradle

# COPY --from=builder /opt/sonar-scanner /opt/sonar-scanner
# RUN chown -R 1001:0 /opt/sonar-scanner && \
#     chmod -R g+rw /opt/sonar-scanner

# ENV GRADLE_HOME=/opt/gradle
# ENV PATH="${PATH}:${GRADLE_HOME}/bin"

# ENV SONAR_HOME=/opt/sonar-scanner
# ENV PATH="${PATH}:${SONAR_HOME}/bin"

# USER 1001

# RUN gradle --version -g ~/.gradle && \
#     sonar-scanner --version