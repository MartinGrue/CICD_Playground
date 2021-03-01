FROM debian
RUN apt-get update -y && \
    apt-get install -y sshpass gnupg ansible 
RUN ansible-galaxy install geerlingguy.jenkins
RUN ansible-galaxy install geerlingguy.java
COPY start.sh /work/
WORKDIR /work

# RUN ["ansible-playbook", "playbooks/jenkins.yml"]
CMD bash /work/start.sh