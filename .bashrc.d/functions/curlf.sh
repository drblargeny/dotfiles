# Function to use curl to follow a redirect link tio inspect its source
function curlf() {
    # -i    Show HTTP headers to capture "Location:" redirects
    # -L    Follow "Location:" redirects to get to the ultimate target page
    curl -iL "$@" 2>&1 | less +G
}

# Alias for handling legacy renegotiation in certain versions of curl
# See details in ~/.openssl-UnsafeLegacyRengotiation.conf
alias curlf.='OPENSSL_CONF=~/.openssl-UnsafeLegacyRengotiation.conf curlf'
