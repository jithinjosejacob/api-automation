# Dockerfile for Browser Tests

FROM mcr.microsoft.com/playwright:v1.40.0-jammy AS build-only 
ARG DEBIAN_FRONTEND=noninteractive 

# Add your source package.json to docker. 
COPY package.json package.json 

WORKDIR /app 
ENV PLAYWRIGHT_BROWSERS_PATH=/playwright/browsers 

RUN apt-get update 
RUN apt-get -y install curl \ 
    libglib2.0-0 \ 
    libnss3 \ 
    libnspr4 \ 
    libatk1.0-0 \ 
    libatk-bridge2.0-0 \ 
    libcups2 \ 
    libdrm2 \ 
    libdbus-1-3 \ 
    libxcb1 \ 
    libxkbcommon0 \ 
    libx11-6 \ 
    libxcomposite1 \ 
    libxdamage1 \ 
    libxext6 \ 
    libxfixes3 \ 
    libxrandr2 \ 
    libgbm1 \ 
    libpango-1.0-0 \ 
    libcairo2 \ 
    libasound2 \ 
    libatspi2.0-0 \ 
    libgtk-3-0 \ 
    libpangocairo-1.0-0 \ 
    libcairo-gobject2 \ 
    libgdk-pixbuf2.0-0 \ 
    libdbus-glib-1-2 \ 
    libxcursor1 \ 
    libxi6 \ 
    libx11-xcb1 
    
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - 
RUN apt-get install -y nodejs 
RUN apt-get update && apt-get install -y awscli 
RUN npm cache clear --force 
RUN npm install 
RUN npx playwright install 
RUN npm link

## APP CONTAINER 
FROM mcr.microsoft.com/playwright:v1.40.0-jammy 
COPY --from=build-only . . 

# Remove prohibited files 
RUN apt-get --purge remove openssh-client rsh-client -y 
RUN rm -rf /usr/lib/apt/methods/rsh \ 
            /etc/ssh \ 
            /usr/bin/ssh \ 
            /bin/mount \ 
            /etc/shadow- \ 
            /etc/passwd- \ 
            /usr/bin/od \ 
            /usr/bin/chfn \ 
            /usr/bin/chsh \ 
            /usr/bin/gpasswd \ 
            /usr/bin/mount \ 
            /usr/bin/newgrp \ 
            /usr/bin/passwd \ 
            /usr/lib/apt/methods/rsh \ 
            /usr/bin/sg \ /usr/bin/su \ 
            /usr/bin/umount \ 
            /usr/lib/dbus-1.0/dbus-daemon-launch-helper \ 
            /usr/lib/openssh/ssh-keysign \ 
            /var/lib/dpkg/alternatives/rsh \ 
            /run/shm 

WORKDIR /app 

CMD npm run test