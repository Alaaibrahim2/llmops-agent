FROM jenkins/jenkins:lts

# التبديل للمستخدم root لتثبيت Docker
USER root

# تحديث النظام وتثبيت Docker
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    sudo

# إضافة مفتاح Docker GPG
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# إضافة مستودع Docker
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# تثبيت Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli

# إضافة المستخدم jenkins لمجموعة docker
RUN usermod -aG docker jenkins

# تثبيت Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# تثبيت Python و pip (للـ AI projects)
RUN apt-get install -y python3 python3-pip

# تنظيف الـ cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# العودة للمستخدم jenkins
USER jenkins

# تثبيت Jenkins plugins الأساسية
RUN jenkins-plugin-cli --plugins \
    docker-workflow \
    docker-plugin \
    pipeline-stage-view \
    git \
    github \
    workflow-aggregator \
    credentials-binding \
    environment-injector

# إنشاء مجلد للـ workspace
RUN mkdir -p /var/jenkins_home/workspace

# Port exposure
EXPOSE 8080 50000

# نقطة الدخول الافتراضية
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]