`sudo -v`

## Access

#### `sudo visudo`

Compare with other servers

#### Set hostname

`sudo hostnamectl set-hostname HOSTNAME`

#### Edit `/etc/hosts`

`sudo vi /etc/hosts`

    203.0.113.#### hostname.example.com hostname
    2600:3c01::a123:b456:c789:d0#### hostname.example.com hostname

#### Add Public Key Authentication

`ssh-keygen -t ed25519 -C "mbeall@starverte.com"`

#### Add SSH key to https://github.com/settings/keys

#### Add SSH key from local machine

`vi .ssh/authorized_keys`

#### Recreate server keys

    sudo rm /etc/ssh/*host*
    sudo dpkg-reconfigure openssh-server

#### Edit `/etc/ssh/sshd_config`

`sudo vi /etc/ssh/sshd_config`

    PermitRootLogin prohibit-password
    PasswordAuthentication no

#### Reload ssh server

`sudo systemctl reload sshd`

#### Test SSH login from local machine

#### Install `fail2ban`

    sudo apt install fail2ban
    sudo ufw allow ssh
    sudo ufw enable
    sudo ufw logging on

## User

#### Reconfigure server time

`sudo dpkg-reconfigure tzdata`

#### Configure default home folders

    sudo mkdir /etc/skel/{private,public}
    sudo chmod 700 /etc/skel/private

#### Add default home folders for current user

    mkdir ~/{private,public}
    sudo chmod 700 ~/private

#### Configure git

    git config --global user.email "mbeall@starverte.com"
    git config --global user.name "Matt Beall"
    git config --global push.default simple
    git config --global init.defaultBranch main

#### Configure hidden files

    cd ~/private
    git clone git@github.com:mbeall/dotfiles.git
    sudo cp -p dotfiles/.bin/ubuntu/* /usr/local/bin/
    cd ~

#### Configure login message

    sudo chmod -x /etc/update-motd.d/10-help-text
    sudo chmod -x /etc/update-motd.d/90-updates-available

    sudo apt install figlet
    sudo cp -p ~/private/dotfiles/update-motd.d/99-footer /etc/update-motd.d/

## Updates

    sudo apt update
    sudo apt upgrade -y
    sudo reboot

    sudo apt-flush
    sudo apt update
    sudo apt upgrade -y
    sudo apt dist-upgrade -y
    sudo reboot

    sudo apt-flush
    sudo apt update
    sudo apt upgrade -y
    why-reboot

#### Edit `50unattended-upgrade`

`sudo vi /etc/apt/apt.conf.d/50unattended-upgrades`

- Uncomment `"${distro_id}:${distro_codename}-updates";`
- Uncomment and edit `Unattended-Upgrade::Mail "admin@starverte.com";`
- Uncomment `Unattended-Upgrade::MailReport "only-on-error";`

#### Install other `apt` software

This command also installs postfix.

`sudo apt install apticron apt-listchanges`

- General type of mail configuration: [Internet Site]
- System mail name: [HOSTNAME.lovelandcreative.com]

`sudo vi /etc/apticron/apticron.conf`

- `EMAIL="admin@starverte.com"`
- `CUSTOM_SUBJECT='[apticron] $SYSTEM: Update(s) available'`

## Email

#### Configure outgoing email server

`sudo vi /etc/postfix/main.cf`

    myhostname = HOSTNAME.lovelandcreative.com

    ...

    relayhost = [smtp.gmail.com]:587

    ...

    # Enable SASL authentication
    smtp_sasl_auth_enable = yes
    # Disallow methods that allow anonymous authentication
    smtp_sasl_security_options = noanonymous
    # Location of sasl_passwd
    smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
    # Enable STARTTLS encryption
    smtp_tls_security_level = encrypt
    # Location of CA certificates
    smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

#### Edit `sasl_passwd`

`sudo vi /etc/postfix/sasl/sasl_passwd`

    [smtp.gmail.com]:587 wp@fortcollinscreative.com:PASSWORD

`sudo postmap /etc/postfix/sasl/sasl_passwd`

#### Edit `virtual`

`sudo vi /etc/postfix/virtual`

    @HOSTNAME.lovelandcreative.com admin@starverte.com

`sudo postmap /etc/postfix/virtual`

#### Lockdown configuration files

    sudo chown root:root /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db
    sudo chmod 0600 /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db

#### Restart postfix

    sudo systemctl restart postfix

## Install LEMP

#### Install Nginx

    sudo apt install nginx

    sudo ufw allow http
    sudo ufw allow https

#### Edit `nginx.conf`

`sudo vi /etc/nginx/nginx.conf`

    client_max_body_size 32M;

    gzip on;
    gzip_vary on;
    gzip_comp_level 6;
    gzip_min_length 256;
    gzip_types
      application/atom+xml
      application/javascript
      application/json
      application/rss+xml
      application/vnd.ms-fontobject
      application/x-font-ttf
      application/x-font-opentype
      application/x-font-truetype
      application/x-javascript
      application/x-web-app-manifest+json
      application/xhtml+xml
      application/xml
      font/eot
      font/opentype
      font/otf
      image/svg+xml
      image/x-icon
      image/vnd.microsoft.icon
      text/css
      text/plain
      text/javascript
      text/x-component;

    gzip_disable "msie6";
    gunzip on;

`sudo systemctl restart nginx`

#### Install Certbot

    sudo apt update
    sudo apt install software-properties-common
    sudo snap install --classic certbot
    sudo ln -s /snap/bin/certbot /usr/bin/certbot

#### Configure Certbot for default domain

`sudo vi /etc/nginx/sites-available/default`

    server_name HOSTNAME.lovelandcreative.com;

`sudo systemctl reload nginx`

`sudo certbot --nginx -d HOSTNAME.lovelandcreative.com`

Select option `2` when prompted.

#### Install MySQL

    sudo apt install mysql-client

#### Install PHP

    sudo apt install php-fpm
    sudo apt install php-mysql php-gd php-imagick php-cli composer php-curl php-xml php-json php-zip
    sudo apt install php-memcached php-redis
    sudo apt install php-ssh2

#### Edit `php.ini`

`sudo vi /etc/php/8.1/fpm/php.ini`

    cgi.fix_pathinfo=0
    post_max_size = 32M
    upload_max_filesize = 32M

    ; Uncode theme recommendations
    memory_limit = 128M
    max_execution_time = 120
    max_input_vars = 3000
    allow_url_fopen = On
    short_open_tag = Off

`sudo service php8.1-fpm restart`

## Misc

#### Install wp-cli

`curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar`

`php wp-cli.phar --info`

    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp

`wp --info`

`wp package install trepmal/wp-revisions-cli`

#### Install utilities

    sudo apt install secure-delete
    sudo apt install mailutils

#### Crontab

`crontab -e`

    00 01  *   *   *  wpg-update-trusted &> /dev/null
    30 01  *   *   1  fccg-sizes &> /dev/null
    00 02  *   *   2  wpg-available-updates &> /dev/null
    30 03  *   *   3  wpg-cleanup &> /dev/null

`sudo crontab -e`

    00  03  01   *    *    fccg-backup
