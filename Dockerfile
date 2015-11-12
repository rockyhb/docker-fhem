FROM centos:6

RUN yum -y update
RUN yum -y install perl perl-Time-HiRes tar openssh-server sudo
RUN yum -y clean all

ENV FHEM_HOME /opt/fhem

# FHEM is ran with user `fhem`, uid = 1000
# If you bind mount a volume from host/volume from a data container, 
# ensure you use same uid
RUN useradd -d "$FHEM_HOME" -u 1000 -m -s /bin/bash fhem

# FHEM home directoy is a volume, so configuration and build history 
# can be persisted and survive image upgrades
VOLUME /opt/fhem

# Add Tini
ENV TINI_VERSION v0.8.3
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD http://fhem.de/fhem-5.6.tar.gz /usr/local/lib/fhem.tar.gz
RUN mkdir -p /usr/share/fhem/ref && cd /usr/share/fhem/ref && tar xvf /usr/local/lib/fhem.tar.gz


EXPOSE 22
EXPOSE 7072
EXPOSE 8083
EXPOSE 8084
EXPOSE 8085

COPY fhem.sh /usr/local/bin/fhem.sh
RUN chmod a+x /usr/local/bin/fhem.sh

COPY fhem.sudo /etc/sudoers.d/fhem
RUN chmod 0400 /etc/sudoers.d/fhem

# USER fhem

# ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/fhem.sh"]
ENTRYPOINT ["/bin/bash"]
