FROM centos:7.6.1810
MAINTAINER ren_mcc <ren_mcc@foxmail.com>

WORKDIR /opt/jumpserver
RUN useradd jumpserver

COPY ./requirements /tmp/requirements

RUN yum -y install epel-release && \
      echo -e "[mysql]\nname=mysql\nbaseurl=https://mirrors.tuna.tsinghua.edu.cn/mysql/yum/mysql57-community-el6/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/mysql.repo
RUN cd /tmp/requirements && yum -y install $(cat rpm_requirements.txt)
RUN ln -sf /usr/bin/python3.6 /usr/bin/python
RUN rpm -ql python3-3.6.8-10.el7.x86_64
RUN pip3 install --upgrade pip3 setuptools && pip3 install -r /tmp/requirements/requirements.txt || pip3 install -r /tmp/requirements/requirements.txt
RUN mkdir -p /root/.ssh/ && echo -e "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null" > /root/.ssh/config

COPY . /opt/jumpserver
VOLUME /opt/jumpserver/data
VOLUME /opt/jumpserver/logs

EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]
