FROM odoo:16

# This dockerfile is run by diploi image builder, it will have 
# this template repository as it's base and the actual project
# repository will be mounted in the repository folder.

# NOTE! Odoo should run as odoo user
USER root

# Fix odoo user to have own homedir 
RUN usermod -d /home/odoo odoo
RUN mkhomedir_helper odoo
RUN usermod --shell /bin/bash odoo
RUN mkdir /home/odoo/.ssh 
RUN chmod 700 ~/.ssh
RUN chown odoo:odoo /home/odoo/.ssh


# Update basic packages
RUN apt-get update && apt-get install -y nano supervisor openssh-server git bash wget curl locales libc6 libstdc++6 ca-certificates tar

# Install PostgreSQL client
#RUN apt-get install -y postgresql-client

RUN mkdir /run/sshd /root/.ssh \
  && chmod 0700 /root/.ssh \
  && ssh-keygen -A \
  && sed -i s/^#PasswordAuthentication\ yes/PasswordAuthentication\ no/ /etc/ssh/sshd_config \
  && sed -i s/root:!/"root:*"/g /etc/shadow \
  # Welcome message
  && echo "Welcome to Diploi!" > /etc/motd \
  # Go to addons folder by default
  && echo "cd /mnt/extra-addons;" >> /root/.bashrc

# Fix LC_ALL: cannot change locale (en_US.UTF-8) error
#RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
#  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
#  echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
#  locale-gen en_US.UTF-8
  
# Gitconfig secrets and credential helper
RUN ln -s /etc/diploi-git/gitconfig /etc/gitconfig
COPY diploi-credential-helper /usr/local/bin

# Experimental add odoo user
RUN apt-get update && apt-get -y install sudo
RUN adduser odoo sudo

# Fake pod ready
RUN touch /tmp/pod-ready

# Init and run supervisor
COPY odoo-start.sh /odoo-start.sh
COPY runonce.sh /root/runonce.sh
COPY supervisord.conf /etc/supervisord.conf
CMD /usr/bin/supervisord -c /etc/supervisord.conf
