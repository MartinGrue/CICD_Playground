FROM python:3.10-rc-buster
ENV PATH="/root/.local/bin:${PATH}"
RUN pip3 install --upgrade pip
RUN pip3 install ansible
RUN pip3 install --user jenkins-job-builder

RUN apt-get update -y && \
    apt-get install -y sshpass python3-apt nano
RUN ansible-galaxy install geerlingguy.jenkins
RUN ansible-galaxy install geerlingguy.java
WORKDIR /work
ADD start.sh .
RUN chmod +x start.sh
CMD ["bash", "./start.sh"]
# CMD ["ansible-playbook", "playbooks/jenkins.yml"]