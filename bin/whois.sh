#!/usr/bin/env bash
# Wrapper script to ensure that whois queries for a domain return the most
# information available

# The first argument should be the domain name
DOMAIN="${1}"

# Run the initial query, which wil provide the info about which registrar
# WHOIS service should be used
whois -H "${DOMAIN}" | \
# Extract the value of the "Registrar WHOIS Server" field
awk -F': ' '($1 ~ /Registrar WHOIS Server$/){print $2}' | \
# Use the "Registrar WHOIS Server" value to lookup the domain to get all  the
# available info
xargs --verbose --no-run-if-empty --delimiter=\\n --max-args=1 -I'{}' whois -Hh '{}' "${DOMAIN}"
