FROM image-registry.openshift-image-registry.svc:5000/openshift/jenkins-agent-base
ENV __doozer=update BUILD_RELEASE=202108312109.p0.git.8f554e2.assembly.stream BUILD_VERSION=v4.8.0 OS_GIT_MAJOR=4 OS_GIT_MINOR=8 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=4.8.0-202108312109.p0.git.8f554e2.assembly.stream SOURCE_GIT_TREE_STATE=clean 
ENV __doozer=merge OS_GIT_COMMIT=8f554e2 OS_GIT_VERSION=4.8.0-202108312109.p0.git.8f554e2.assembly.stream-8f554e2 SOURCE_DATE_EPOCH=1626996972 SOURCE_GIT_COMMIT=8f554e2ad7ab8636cdbf55b5d0bde4577a5c0af6 SOURCE_GIT_TAG=8f554e2 SOURCE_GIT_URL=https://github.com/openshift/jenkins 
MAINTAINER OpenShift Developer Services <openshift-dev-services+jenkins@redhat.com>

# Labels consumed by Red Hat build service

ENV MAVEN_VERSION=3.5 \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    MAVEN_OPTS="-Duser.home=$HOME"
# TODO: Remove MAVEN_OPTS env once cri-o pushes the $HOME variable in /etc/passwd

# Install Maven
RUN INSTALL_PKGS="maven java-1.8.0-openjdk-devel" && \
    yum module enable -y maven:${MAVEN_VERSION} && \
    yum install -y $INSTALL_PKGS && \
    rpm -V maven java-1.8.0-openjdk-devel && \
    yum clean all -y && \
    mkdir -p $HOME/.m2

ADD contrib/bin/configure-agent /usr/local/bin/configure-agent
ADD ./contrib/settings.xml $HOME/.m2/

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001

LABEL \
        com.redhat.component="ose-jenkins-agent-maven-container" \
        name="openshift/ose-jenkins-agent-maven" \
        architecture="x86_64" \
        io.k8s.display-name="Jenkins Agent Maven" \
        io.k8s.description="The jenkins agent maven image has the maven tools on top of the jenkins agent base image." \
        io.openshift.tags="openshift,jenkins,agent,maven" \
        maintainer="openshift-dev-services+jenkins@redhat.com" \
        License="GPLv2+" \
        vendor="Red Hat" \
        io.openshift.maintainer.product="OpenShift Container Platform" \
        io.openshift.maintainer.component="Jenkins" \
        release="202108312109.p0.git.8f554e2.assembly.stream" \
        io.openshift.build.commit.id="8f554e2ad7ab8636cdbf55b5d0bde4577a5c0af6" \
        io.openshift.build.source-location="https://github.com/openshift/jenkins" \
        io.openshift.build.commit.url="https://github.com/openshift/jenkins/commit/8f554e2ad7ab8636cdbf55b5d0bde4577a5c0af6" \
        version="v4.8.0"
