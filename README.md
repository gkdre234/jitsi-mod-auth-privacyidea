# jitsi-mod-auth-privacyidea
plugin to authenticate Jitsi Meet against PrivacyIDEA 

# Required debian packages

~~~~shell
apt install httpie
apt install lua-pty
~~~~

# Install:
~~~~shell
Copy the mod_auth_external.lua to your modules directory like /usr/lib/prosody/modules/.
Copy the JSON.sh and prosody-auth-pi.sh to /usr/local/bin/.
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
        

~~~~

