# Jupyter version 281505737f8a (Oct. 06, 2017)
FROM jupyter/minimal-notebook:281505737f8a

LABEL maintainer="Anastasios Skarlatidis"

# -----------------------------------------------------------------------------
# --- Constants
# -----------------------------------------------------------------------------

# Set the desired version of jupyter-scala
ENV JUPYTER_SCALA_VERSION="0.4.2"

# Set the desired version of SBT
ENV SBT_VERSION="0.13.15"

# -----------------------------------------------------------------------------
# --- Install depenencies (distro packages)
# -----------------------------------------------------------------------------

USER root

# Install software-properties and curl
RUN \
  apt-get update \
  && apt-get install -y software-properties-common python-software-properties \
  && apt-get install -y curl 

# Install Oracle JDK version 8
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true \
  | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH=${PATH}:${JAVA_HOME}/bin

# -----------------------------------------------------------------------------
# --- Download and install Jupyter-Scala, the Llightweight Scala kernel for 
# --- Jupyter / IPython 3. 
# --- For details, see https://github.com/jupyter-scala/jupyter-scala
# -----------------------------------------------------------------------------

# Download SBT
RUN curl -sL --retry 5 "https://github.com/sbt/sbt/releases/download/v0.13.15/sbt-0.13.15.tgz" \
  | gunzip \
  | tar -x -C "/tmp/" \
  && mv "/tmp/sbt" "/opt/sbt-${SBT_VERSION}" \
  && chmod +x "/opt/sbt-${SBT_VERSION}/bin/sbt"

ENV PATH=${PATH}:/opt/sbt-${SBT_VERSION}/bin/

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER

# Download jupyter-scala
RUN curl -sL --retry 5 "https://github.com/jupyter-scala/jupyter-scala/archive/v${JUPYTER_SCALA_VERSION}.tar.gz" \
  | gunzip \
  | tar -x -C "/tmp/" 

# Build jupyter-scala for Scala 2.11 and 2.12
RUN cd "/tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}" && \
  /opt/sbt-${SBT_VERSION}/bin/sbt ++2.11.11 ++2.12.2 publishLocal

# Install kernel for Scala 2.11
RUN cd /tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}/ \
  && ./jupyter-scala --id scala_2_11 --name "Scala (2.11)" --force

# Install kernel for Scala 2.12
RUN cd /tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}/ \
  && sed -i 's/\(SCALA_VERSION=\)\([2-9]\.[0-9][0-9]*\.[0-9][0-9]*\)\(.*\)/\12.12.2\3/' jupyter-scala \
  && ./jupyter-scala --id scala_2_12 --name "Scala (2.12)" --force
  
RUN rm -r /tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}/

RUN rm -r /home/$NB_USER/.sbt/*
RUN rm -r /home/$NB_USER/.ivy2/*
RUN rm -r /home/$NB_USER/.ivy2/.sbt*
RUN rm -r /home/$NB_USER/.coursier/*

WORKDIR /home/$NB_USER/work