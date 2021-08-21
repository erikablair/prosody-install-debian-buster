<div align="center"><h1> prosody-install-debian-buster</h1></div>     

<div align="center">Working prosody.cfg.lua with the exception of SRV record -- Debian Buster</div><br>      
          

<div align="center"> <b>! ! DISCLAIMER ! !</b> </div>     
   
I have no idea what I'm doing!  This was strung together through several 
different tutorials *(written and video)*, [prosody.im](https://prosody.im/) 
documentation, [XMPP Compliance Tester](https://compliance.conversations.im/add/) 
error logs, client *(babble.im)* error *helpers*, and good old fashioned trial and error. 
 There are assuredly errors and redundancies in the config files but, it seems like all 
 services are working.  Encrypted messaging, group messaging, and file sharing are working
 including android to android audio and video calls.  I will add to this as 
 I continue configuration testing to hopefully eliminate errors and 
 redundancies.<br></br>
You will first have to setup *(at minimum)* an "A" record with a [DNS provider.](https://freedns.afraid.org/freedns.afraid.org)  
* *There are many tutorials on how to create a cron job to 
keep your ip address associated with your DNS provider.*   

 
Make a new directory in your home folder to clone this repo to...     

* `mkdir ~/.tmp`     
* `cd ~/.tmp`     
* `git clone https://github.com/erikablair/prosody-install-debian-buster.git`     
* `cd prosody-install-debian-buster`     

Open prosody.cfg.lua and prosody.conf; and replace all *example.com* with your chosen DNS.  This is easily accomplished with substitution in vim...   
* `:%s/example.com/yourDNShere.com`  then;   
* `:wq` to save and quit.        

After you have installed Prosody and Nginx copy prosody.cfg.lua and prosody.conf to the
appropriate locations...   
* `sudo cp ~/.tmp/prosody.cfg.lua /etc/prosody/`   
* `sudo cp ~/.tmp/prosody.conf /etc/nginx/conf.d/`

*Be sure to take note of all ports listed in prosody.cfg.lua!  They will have to be allowed by your firewall and forwarded on your router.*
* *tcp ports-*
    * *80, 443, 3478, 5222, 5269, 5281, 5349, 5280, 5281* 

### Dependencies
* `sudo apt install luarocks lua5.2 lua-zlib lua-socket lua-sec
 lua-ldap lua-filesystem lua-expat lua-event lua-dbi-sqlite3
 lua-dbi-postgresql lua-lib-mysql lua-dbi-common lua-bitop
 lua-bit32 mercurial nginx-full`

* `luarocks install luaunbound`

### Add prosody repo to apt sources list, download authentication key, & install prosody
* This is just one way to accomplish this
    * `sudo apt-add-repository deb https://packages.prosody.im/debian buster main`
* Add Prosody key file
    * `wget https://prosody.im/files/prosody-debian-packages.key -O- | sudo apt-key add -`
* Update apt to synchronize new repositories
    * `sudo apt update`
* Install prosody
    * `sudo apt install prosody`
* Create a backup prosody.cfg.lua that shipped with the debian prosody package *(just in case)*
    * `sudo cp /etc/prosody/prosody.cfg.lua /etc/prosody/prosody.cfg.lua.bak`
* Copy new config to appropriate location
    * `sudo cp ~/.tmp/prosody.cfg.lua /etc/prosody/prosody.cfg.lua`   

### Nginx configuration
* Copy prosody.conf file to `/etc/nginx/conf.d/`
    * `sudo cp ~/.tmp/prosody.conf /etc/nginx/conf.d/`     

### Set up Turn Server for Discoverability
* Install co-Turn
    * `sudo apt install coturn`

* Edit coturn config file located at `/etc/turnserver.conf`
    * search for "realm", uncomment, and add the following lines
        * realm=turn.example.com
        * use-auth-secret
        * static-auth-secret=supersecretpassword    
        
         
To the best of my knowledge; this secret needs to match in two places in 
prosody.cfg.lua at lines 135 `turncredentials_secret =` and 151 
`external_service_secret =`     

### Add additional prosody modules
* Download prosody community modules to a suitable directory
    * `sudo hg clone https://hg.prosody.im/prosody-modules/prosody-modules`

* Make a new directory (you may have to login as root depending on permissions)
    * `sudo mkdir /usr/local/lib/prosody/modules-enabled`

* Copy mod_mam folder to moduled-enabled dir
    * `sudo cp /usr/lib/prosody/modules /usr/local/lib/prosody/modules-enabled`

* Useful community mods to copy to modules-enabled dir
    * mod_adhoc_groups.lua
    * mod_auto156.lua
    * mod_bookmarks.lua
    * mod_cloud_notify.lua
    * mod_extdisco.lua
    * mod_external_services.lua
    * mod_http_altconnect.lua
    * mod_http.lua
    * mod_mam_adhoc.lua
    * mod_mam_muc.lua
    * mod_omemo_all_access.lua
    * mod_smacks.lua
    * mod_turncredentials.lua
    * mod_vcard_muc.lua


### Install certbot (LetsEncrypt) and generate certs
##### Instructions from [Certbot](https://certbot.eff.org/lets-encrypt/debianbuster-nginx)
* Install snapd
    * `sudo apt install snapd`
* Log out or Restart to ensure snap path updates correctly, then install core
    * `sudo snap install core; sudo snap refresh core`
* Install certbot
    * `sudo snap install --classic certbot`
* Link directories
    * `sudo ln -s /snap/bin/certbot /usr/bin/certbot`
* Create prosody web root dir
    * `sudo mkdir /var/www/prosody/`
* Set www-data (nginx user) as owner of web root dir
    * `sudo chown www-data:www-data /var/www/prosody -R`
* Reload nginx
    * `sudo systemctl reload nginx`
* Generate TLS certificate
    * `sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email you@example.com -d example.com`
* Test certificate renewal
    * `sudo certbot renew --dry-run`  
     
Certbot creates a cron job for auto-renewal at `/etc/cron.d/certbot`
* Automate certificate renewal *(How I did it - may need to be root)*
    * `touch /var/spool/cron/crontabs/root`
    * `cat /etc/cron.d/certbot >> /var/spool/cron/crontabs/root`

