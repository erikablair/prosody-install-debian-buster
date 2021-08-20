# prosody_cfg_buster
Working prosody.cfg.lua with the exception of SRV record -- Debian Buster


*Be sure to take note of all ports listed in prosody.cfg.lua!  They will have to be allowed by your firewall and forwarded on your router.*
* *tcp ports-*
    * *80, 443, 3478, 5222, 5269, 5281, 5349, 5280, 5281* 

### Add prosody repo to apt list, download authentication key, & install prosody
* This is just one way to accomplish this
    * `sudo apt-add-repository deb https://packages.prosody.im/debian buster main`
* Add Prosody key file
    * `wget https://prosody.im/files/prosody-debian-packages.key -O- | sudo apt-key add -`
* Update apt to synchronize new repositories
    * `sudo apt update`
* Install prosody
    * `sudo apt install prosody`

### Dependencies
* `sudo apt install luarocks lua5.2 lua-zlib lua-socket lua-sec
 lua-ldap lua-filesystem lua-expat lua-event lua-dbi-sqlite3
 lua-dbi-postgresql lua-lib-mysql lua-dbi-common lua-bitop
 lua-bit32 mercurial`

* `luarocks install luaunbound`

### Set up Turn Server for Discoverability
* Install co-Turn
    * `sudo apt install coturn`

* Edit coturn config file located at /etc/turnserver.conf
    * search for "realm", uncomment, and add the following lines
        * realm=turn.example.com
        * use-auth-secret
        * static-auth-secret=supersecretpassword

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
    * mod_http_upload_external.lua
    * mod_mam_adhoc.lua
    * mod_mam.lua
    * mod_mam_muc.lua
    * mod_omemo_all_access.lua
    * mod_require_otr.lua
    * mod_smacks.lua
    * mod_turncredentials.lua
    * mod_vcard_muc.lua


### Install certbot (LetsEncrypt) and generate certs
##### Instructions from https://certbot.eff.org/lets-encrypt/debianbuster-nginx
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
* Generate TLS certificte
    * `sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email you@example.com -d example.com`


