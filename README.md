# jitsi-mod-auth-privacyidea
plugin to authenticate Jitsi Meet against PrivacyIDEA 

# Required debian packages

~~~~shell
apt install httpie
apt install lua-lpty
~~~~

# Install:
~~~~shell
Copy the mod_auth_external.lua to your modules directory like /usr/lib/prosody/modules/.
Copy the JSON.sh and prosody-auth-pi.sh to /usr/local/bin/.

chmod +x /usr/local/bin/JSON.sh
chmod +x /usr/local/bin/prosody-auth-pi.sh
~~~~

# Setup:

~~~~shell
VirtualHost "meet.example.org"
        -- enabled = false -- Remove this line to enable this host
        -- authentication = "internal_plain"
        authentication = "external"
        external_auth_protocol = "generic"
        external_auth_command = "/usr/local/bin/prosody-auth-pi.sh"
        external_auth_timeout = 10
        -- Properties below are modified by jitsi-meet-tokens package config
...

~~~~
Secure Your Jitsi Domain
(Gguide: https://github.com/jitsi/jicofo#secure-domain)

Modify LoginDialog.js
~~~~shell
--- jitsi-orig/jitsi-meet/modules/UI/authentication/LoginDialog.js	2020-10-08 17:32:18.484057855 +0200
+++ jitsi-local/jitsi-meet/modules/UI/authentication/LoginDialog.js	2020-10-08 15:12:50.803658853 +0200
@@ -12,7 +12,7 @@
 function getPasswordInputHtml() {
     const placeholder = config.hosts.authdomain
         ? 'user identity'
-        : 'user@domain.net';
+        : 'user#realm';
 
     return `
         <input name="username" type="text"

~~~~

# Login
Username  : user#realm

Password  : token


![Alt text](login-prompt.png?raw=true "Login prompt")

