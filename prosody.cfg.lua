-- Prosody Example Configuration File
--
-- If it wasn't already obvious, -- starts a comment, and all 
-- text after it on a line is ignored by Prosody.
--
-- The config is split into sections, a global section, and one 
-- for each defined host that we serve. You can add as many host 
-- sections as you like.
--
-- Lists are written
_ = { "like", "this", "one" } 
-- Lists can also be of { 1, 2, 3 } numbers, etc. 
-- Either commas, or semi-colons; may be used
-- as separators.
--
-- A table is a list of values, except each value has a name. An 
-- example would be:
--
examlpe_ssl = { key = "keyfile.key", certificate = "certificate.crt" }
--
-- Whitespace (that is tabs, spaces, line breaks) is mostly insignificant, so 
-- can 
-- be placed anywhere
-- that   you deem fitting.
--
-- Tip: You can check that the syntax of this file is correct
-- when you have finished by running this command:
--     prosodyctl check config
-- If there are any errors, it will let you know what and where
-- they are, otherwise it will keep quiet.
--
-- The only thing left to do is rename this file to remove the .dist ending, and fill in the
-- blanks. Good luck, and happy Jabbering!


---------- Server-wide settings ----------
-- Settings in this section apply to the whole server and are the default settings
-- for any virtual hosts

-- This is a (by default, empty) list of accounts that are admins
-- for the server. Note that you must create the accounts separately
-- (see https://prosody.im/doc/creating_accounts for info)
-- Example: admins = { "user1@example.com", "user2@example.net" }
admins = { "user@example.com" }

-- Enable use of libevent for better performance under high load
-- For more information see: https://prosody.im/doc/libevent
--use_libevent = true

-- Prosody will always look in its source directory for modules, but
-- this option allows you to specify additional locations where Prosody
-- will look for modules first. For community modules, see https://modules.prosody.im/
plugin_paths = { "/usr/local/lib/prosody/modules-enabled" }

-- This is the list of modules Prosody will load on startup.
-- It looks for mod_modulename.lua in the plugins folder, so make sure that exists too.
-- Documentation for bundled modules can be found at: https://prosody.im/doc/modules
modules_enabled = {

    -- Generally required
        "roster"; -- Allow users to have a roster. Recommended ;)
        "saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
        "tls"; -- Add support for secure TLS on c2s/s2s connections
        "dialback"; -- s2s dialback support
        "disco"; -- Service discovery
	"extdisco"; -- Service discovery EXTERNAL
	"iq"; -- Core XMPP functionality

    -- Not essential, but recommended
        "carbons"; -- Keep multiple clients in sync
        "pep"; -- Enables users to publish their avatar, mood, activity, playing music and more
        "private"; -- Private XML storage (for room bookmarks, etc.)
        "blocklist"; -- Allow users to block communications with other users
        "vcard4"; -- User profiles (stored in PEP)
        "vcard_legacy"; -- Conversion between legacy vCard and PEP Avatar, vcard

    -- Nice to have
        "version"; -- Replies to server version requests
        "uptime"; -- Report how long server has been running
        "time"; -- Let others know the time here on this server
        "ping"; -- Replies to XMPP pings with pongs
        "register"; -- Allow users to register on this server using a client and change passwords
        "mam"; -- Store messages in an archive and allow users to access it
        "csi_simple"; -- Simple Mobile optimizations
	"csi"; -- Allows Client to report active/inactive state

    -- Admin interfaces
        "admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
        "admin_telnet"; -- Opens telnet console interface on localhost port 5582

    -- HTTP modules
        "bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
        --"websocket"; -- XMPP over WebSockets
        "http_files"; -- Serve static files from a directory over HTTP

    -- PubSub entries - to publish and subscribe
        "pubsub";
	"pubsub_feeds";
	"pubsub_mqtt";
	"pubsub_text_interface";

    -- Other specific functionality
        --"posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
	"watchregistrations"; -- Alert admins of registrations
        "limits"; -- Enable bandwidth limiting for XMPP connections
        "groups"; -- Shared roster support
        --"server_contact_info"; -- Publish contact information for this service
        "announce"; -- Send announcement to all online users
        "welcome"; -- Welcome users who register accounts
        "watchregistrations"; -- Alert admins of registrations
        --"motd"; -- Send a message to users when they log in
        "legacyauth"; -- Legacy authentication. Only used by some old clients and bots.
        "proxy65"; -- Enables a file transfer proxy service which clients behind NAT can use
	"smacks"; -- Enables Stream Management
	"cloud_notify"; -- Push notifications
	"bookmarks"; -- Room bookmarks
	"http_upload"; -- file sharing
	"http_altconnect"; -- Turn & Stun Service
	--"http"; -- http server
	--"http_upload_external"; -- For larger file sharing
	"external_services"; -- Turn & Stun Service
	"turncredentials"; -- Turn & Stun credentials
	"user_account_management"; -- Enables User password change
	--"register_ibr"; -- In Band User account creation
}

-- File sharing config
--http_upload_path = "/var/tmp"
http_files_dir = "/var/www"
mime_types_file = "/etc/mime.types"
http_files_cache_max_file_size = "4096"
http_upload_file_size_limit = "10000000"

-- Bosh server config
http_ports = { 5280 }
http_interfaces = { "*", "::" }

https_ports = { 5281 }
https_interfaces = { "*", "::" }

consider_bosh_secure = true;
cross_domain_bosh = true;

-- Welcome message
welcome_message = "Hey $username! Welcome to $host, glad you're here!"

-- Bandwidth limiting config -- rate limits for incoming client and server connections
limits = {
  c2s = {
    rate = "10kb/s";
  };
  s2sin = {
    rate = "30kb/s";
  };
}

-- Turn & Stun credential config
turncredentials_secret = "supersecretpassword"
turncredentials_host = "turn.example.com"
turncredentials_port = "3478"
turncredentials_ttl = "86400"

-- Turn & Stun service discovery config
external_service_secret = "supersecretpassword";
external_services = {
     {
        type = "stun",
	transport = "tcp",
	host = "example.com",
	port = 3478,
     }, {
        type = "turn",
	transport = "tcp",
	host = "example.com",
	port = 3478,
	secret = true,
	ttl = 86400,
	algorithm = "turn",
     }, {
        type = "turns",
	host = "example.com",
        port = 5349,
	transport = "tcp",
	secret = true,
	ttl = 86400,
	algorithm = "turn",
     }
};


-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
    -- "offline"; -- Store offline messages
    -- "c2s"; -- Handle client connections
    -- "s2s"; -- Handle server-to-server connections
    -- "posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
}

-- Disable account creation by default, for security
-- For more information see https://prosody.im/doc/creating_accounts
allow_registration = true
min_seconds_between_registrations = 21600

-- Debian:
--   Do not sent the server to background, either systemd or start-stop-daemon take care of that.
daemonize = false;

-- Debian:
--    Please, don't change this option since /run/prosody/
--    is one of the few directiories Prodody is allowed to write to
--    Required for init scripts and prosodyctl 
pidfile = "/run/prosody/prosody.pid";

-- Force clients to use encrypted connections? This option will
-- prevent clients from authenticating unless they are using encryption.

c2s_require_encryption = true

-- Force servers to use encrypted connections? This option will
-- prevent servers from authenticating unless they are using encryption.

s2s_require_encryption = true

-- Force certificate authentication for server-to-server connections?

s2s_secure_auth = false

-- Some servers have invalid or self-signed certificates. You can list
-- remote domains here that will not be required to authenticate using
-- certificates. They will be authenticated using DNS instead, even
-- when s2s_secure_auth is enabled.

--s2s_insecure_domains = { "insecure.example" }

-- Even if you disable s2s_secure_auth, you can still require valid
-- certificates for some domains by specifying a list here.

--s2s_secure_domains = { "jabber.org" }

-- Select the authentication backend to use. The 'internal' providers
-- use Prosody's configured data storage to store the authentication data.

authentication = "internal_hashed"

-- Select the storage backend to use. By default Prosody uses flat files
-- in its configured data directory, but it also supports more backends
-- through modules. An "sql" backend is included by default, but requires
-- additional dependencies. See https://prosody.im/doc/storage for more info.

--storage = "sql" -- Default is "internal"

-- For the "sql" backend, you can uncomment *one* of the below to configure:
--sql = { driver = "SQLite3", database = "prosody.sqlite" } -- Default. 'database' is the filename.
--sql = { driver = "MySQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }
--sql = { driver = "PostgreSQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }


-- Archiving configuration
-- If mod_mam is enabled, Prosody will store a copy of every message. This
-- is used to synchronize conversations between multiple clients, even if
-- they are offline. This setting controls how long Prosody will keep
-- messages in the archive before removing them.

archive_expires_after = "1w" -- Remove archived messages after 1 week

-- You can also configure messages to be stored in-memory only. For more
-- archiving options, see https://prosody.im/doc/modules/mod_mam

-- Logging configuration
-- For advanced logging see https://prosody.im/doc/logging
log = {
    info = "prosody.log"; -- Change 'info' to 'debug' for verbose logging
    error = "prosody.err";
    -- "*syslog"; -- Uncomment this for logging to syslog
    -- "*console"; -- Log to the console, useful for debugging with daemonize=false
}

-- Uncomment to enable statistics
-- For more info see https://prosody.im/doc/statistics
-- statistics = "internal"

-- Certificates
-- Every virtual host and component needs a certificate so that clients and
-- servers can securely verify its identity. Prosody will automatically load
-- certificates/keys from the directory specified here.
-- For more information, including how to use 'prosodyctl' to auto-import certificates
-- (from e.g. Let's Encrypt) see https://prosody.im/doc/certificates

-- Location of directory to find certificates in (relative to main config file):
certificates = "/etc/prosody/certs"

-- HTTPS currently only supports a single certificate, specify it here:
--https_certificate = "certs/localhost.crt"
https_ssl = {
	certificate = "/etc/letsencrypt/live/example.com/fullchain.pem";
	key = "/etc/letsencrypt/live/example.com/privkey.pem";
}
----------- Virtual hosts -----------
-- You need to add a VirtualHost entry for each domain you wish Prosody to serve.
-- Settings under each VirtualHost entry apply *only* to that host.

VirtualHost "localhost"
ssl = {
	certificate = "/etc/letsencrypt/live/example.com/fullchain.pem";
	key = "/etc/letsencrypt/live/example.com/privkey.pem";
}

VirtualHost "example.com"

ssl = {
	certificate = "/etc/letsencrypt/live/example.com/fullchain.pem";
	key = "/etc/letsencrypt/live/example.com/privkey.pem";
}

--disco_items = {
--	{ "upload.example.com" },
--}

--VirtualHost "example.com"
--  certificate = "/path/to/example.crt"

------ Components ------
-- You can specify components to add hosts that provide special services,
-- like multi-user conferences, and transports.
-- For more information on components, see https://prosody.im/doc/components

---Set up a MUC (multi-user chat) room server on conference.example.com:
Component "conference.example.com" "muc"
--- Store MUC messages in an archive and allow users to access it
modules_enabled = { "muc_mam"; "vcard_muc"; "omemo_all_access"; }

-- Proxy65 to transfer files
Component "proxy.example.com" "proxy65"
    proxy65_address = "upload.example.com"
    proxy65_acl  = "example.com"
   
-- Broadcast - ServerWide Announcements
Component "broadcast@example.com" "broadcast"

---Set up an external component (default component port is 5347)
--
-- External components allow adding various services, such as gateways/
-- transports to other networks like ICQ, MSN and Yahoo. For more info
-- see: https://prosody.im/doc/components#adding_an_external_component
--
--Component "gateway.example.com"
--  component_secret = "password"
--

