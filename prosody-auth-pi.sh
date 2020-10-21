#!/bin/bash

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
AUTH_OK=1
AUTH_FAILED=0
USELOG=true

log() {
  if [ ${USELOG} = true ]
  then
   /usr/bin/logger -t prosody-auth-pi -p auth.info "= $@"
  fi
}

PI_URL="https://your.privacyidea.server/validate/check"
USER_AGENT="jitsi"
CHECK_SSL=0
HTTP_CMD="/usr/bin/http"
ADD_REALM_TO_USERNAME_AT=true
ADD_REALM_TO_USERNAME_AT_EXCLUDE="realm1 realm2.suffix realm3.suf.fix"

#Auth input ACTION:USERSTRING:HOST:PASS  # ACTION and HOST ignored...
while read AUTH_INPUT ; do
    USERSTRING=$(echo "${AUTH_INPUT}" | cut -d : -f 2)
    PASS=$(echo "${AUTH_INPUT}" | cut -d : -f 4)

    log "Action=$ACTION Userstring=$USERSTRING Host=$HOST Pass=$PASS"

    if [[ ${USERSTRING} = *#* ]]
    then
     USERSTRING=$(echo "${USERSTRING}" | sed -e "s/#/@/g")
     USER_PART=$(echo "${USERSTRING}" | cut -d @ -f 1)
     REALM_PART=$(echo "${USERSTRING}" | cut -d @ -f 2)
     REALM="${REALM_PART}"
     if [ ${ADD_REALM_TO_USERNAME_AT} == true ]; then USER="${USER_PART}@${REALM_PART}"; fi
     if echo "${ADD_REALM_TO_USERNAME_AT_EXCLUDE}" | egrep -q "([^[:alnum:].]|^)${REALM_PART}([^[:alnum:].]|$)" ; then USER="${USER_PART}"; fi
    else
     USER="${USERSTRING}"
     REALM=""
    fi

    log "validate/check User=${USER} Realm=${REALM} Pass=$PASS"

    HTTP_CMD_OUTPUT=$(${HTTP_CMD} --ignore-stdin --check-status ${PI_URL} user-agent:${USER_AGENT} user=${USER} realm=${REALM} pass=${PASS} 2>/dev/null)
    RESULT=$?
    if [ ${RESULT} != 0 ]
    then
     log "User=$USER Realm=${REALM} http-status=${RESULT} auth failed"
     echo "${AUTH_FAILED}"
    else
     JSON_OUTPUT=$(echo "${HTTP_CMD_OUTPUT}" | JSON.sh -b)
     AUTH_STATUS=$(echo "${JSON_OUTPUT}" | grep "\[\"result\",\"value\"\]" | cut -s -f 2)
     AUTH_MESSAGE=$(echo "${JSON_OUTPUT}" | grep "\[\"detail\",\"message\"\]" | cut -s -f 2)
     TOKEN_SERIAL=$(echo "${JSON_OUTPUT}" | grep "\[\"detail\",\"serial\"\]" | cut -s -f 2)
     if [ "${AUTH_STATUS}" == "true" ]
     then
      echo "${AUTH_OK}"
     else
      echo "${AUTH_FAILED}"
     fi
     log "validate/response User=$USER Realm=${REALM} http-status=${RESULT} auth=${AUTH_STATUS} message=${AUTH_MESSAGE} token-serial=${TOKEN_SERIAL}"
    fi
done
