#!/usr/bin/env bash

set -o errexit  # Stop Script if Command Error
set -o nounset  # Stop Script if Any Varible is not defined
set -o pipefail # Stop Script if Command Pipe fails

################################################################
################################################################

# ================= NOTES =================

# ASCII Table Generator --> https://ozh.github.io/ascii-tables/

# ASCII Image Generator --> https://manytools.org/hacker-tools/convert-images-to-ascii-art/

# ASCII Image Generator --> https://www.asciiart.eu/image-to-ascii

# ASCII Text Generator --> https://manytools.org/hacker-tools/ascii-banner/

# BUILD NOTES -->

            # Define an Standard Array         -->       array=()
            # Define an Standard Array         -->       [readarray | mapfile] -t array_name < <(command output)     --> Useful to Storage any Elements' Set on Array

            # Define Asociative Array -->       declare -A aso_array    --> Like Python Dictionaries or JSON Objects

            # Delete Duplicate Standard Array Elements With Asociative_ Array --> for i in "${array[@]}"; do aso_array[$i]=1; done
            #                                                                     new_array=("${!aso_array[@]}")  

            # All Array elements      -->       "${array[@]}" or "${array[*]}"
            # Array Length            -->       "${#array[@]}"
            # Add Elements to Array   -->       array+=("")

            # Loop Over Array Values  -->       for i in "${array[@]}"
            # Loop Over Array Indexes -->       for i in "${!array[@]}"       --> Useful to Generate New Array with Non Duplicate Elements

            # Storage Array Elements on Loop Without Remove between them  --> for i in "${array1[@]}"; do

            #                                                                       mapfile -t -O "${#array2[@]}" array2 < <(command output) 

            #                                                                 done

########## SSL CERTS GATHERING DATA TOOLS ##########

# CRT.SH -->      Gather and Handle Information from Web Through CURL - JQ Combination

#                 More Powerfull Usage Gathering Info via PSQL Client --> psql -h crt.sh -p 5432 -U guest certwatch

#                 Both Ways using CRT.SH have UNLIMITED HTTP API REQUESTS

# CENSYS -->      Gather and Handle Information from Web Through CURL - JQ Combination

#                 LIMITED HTTP API REQUESTS --> FREE PLAN --> 250 HTTP API REQUESTS / MONTH (ATM)

# SSLMATE -->     https://sslmate.com/ct_search_api/ --> ANOTHER SSL CERTS GATHERING TOOL --> 100 QUERIES / HOUR

########## IP INFO GATHERING DATA TOOLS ##########

# IPINFO -->      https://ipinfo.io/developers --> curl --silent https://ipinfo.io/"${IP_ADDRESS}"/json --> 50 000 API REQUESTS / MONTH

################################################################
################################################################

# BANNERS AND HELP FUNCTION

banner(){

cat <<'BANNER'

     ██████╗ ███████╗██╗   ██╗ ██████╗ ███╗   ██╗██████╗ ███████╗██╗      █████╗ ██████╗ ███████╗
     ██╔══██╗██╔════╝╚██╗ ██╔╝██╔═══██╗████╗  ██║██╔══██╗██╔════╝██║     ██╔══██╗██╔══██╗██╔════╝
     ██████╔╝█████╗   ╚████╔╝ ██║   ██║██╔██╗ ██║██║  ██║█████╗  ██║     ███████║██████╔╝█████╗  
     ██╔══██╗██╔══╝    ╚██╔╝  ██║   ██║██║╚██╗██║██║  ██║██╔══╝  ██║     ██╔══██║██╔══██╗██╔══╝  
     ██████╔╝███████╗   ██║   ╚██████╔╝██║ ╚████║██████╔╝██║     ███████╗██║  ██║██║  ██║███████╗
     ╚═════╝ ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝                         
                                                                 
                 ░▒██████████░░               
              ░██░░░░░░░░░░░░░░░░██░           
              █░░░░░░░░░░░░░░░░░░░░█           
             ▒░░░████░░▓░░▓░░███▒░░█           
             █░░░░░░░░█░░░██░░░░░░░█           
             █░░░▒███░░░░░░░████░░░█           
             █░░░░░░░░░░░░░░░░░░░░░█░          
             █░░░░░░░░░░░░░░░░░░░░░█           
              █░░░░░░░░░░░░░░░░░░░░█           
           ██░█░░░█░░░░▓██░░░░░██░░█           
          ▓█░█▒░░▓░█████░░████░░░░█░           
          █░████░░░░░░░░░░░░░░░░░█             
          █░██████░░░░░░██░░░░░░█              
          ░████████▒░░░███░░░░█▓               
            ░▒███████░░░██░░███░               
                ░████░░██████████░             
                 █████░██░█████████            
                ░███████████████████           
               ░███████████████████░█░         
            ░░░██████████████  ███░██░         
            █████████  ██████░ ░████           
             ███████░  ██████▒                 
                ████   ██████                  
                      ████████                 
                      ░███████░  
      
BANNER

}

banner1(){

cat <<'BANNER'                                                                                                          
   █████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗
   ╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝                                                                                                                                                             

BANNER

}

help(){

banner

cat <<'HELP'

     Description: This script extracts Information about a given Domain Name using:

      Censys | crt.sh | IPINFO

     Syntax: beyondflare.sh [-d|-s|-c|-h]

     Usage: beyondflare.sh [-d domain_name] {-s}{-c}{-h}


     Options:

     -d --> Specify Domain Name ; e.g. beyondflare.sh -d example.com

     -s --> Subdomains Enumeration ; e.g. beyondflare.sh -d example.com -s

     -c --> Origin IP Addresses Set Enumeration ; e.g. beyondflare.sh -d example.com -c

     -h --> Display This Help and Exit

HELP

}

################################################################
################################################################

# DEPS - TOOLS (EXECUTABLE) - INSTALLED CHECK

die(){

      banner

      echo; echo -e "     Fatal Error --> ${1}\n" >&2

      exit 1

}

installed_and_executable(){

      cmd=$(command -v "${1}")

      test -n "${cmd}" && test -f "${cmd}" && test -x "${cmd}"

      return ${?}
}

check_deps(){

      local deps=(jq curl atop)

      for i in "${deps[@]}"; do

            installed_and_executable "${i}" || die "Missing '${i}' dependency or not executable\n \

            Installation Command --> [apt|yum|dnf] install ${i} -y"

      done

}

################################################################
################################################################

# CENSYS SSL CERTIFICATES - FINGERPRINT SHA256 SSL CERT (LIMITED TO 250 API REQUEST / MONTH)

get_sha256_fingerprints(){

      local domain=$1

      local uri="https://search.censys.io/api/v2/certificates/search"

      local search_string="?q=${domain}"

      mapfile -t fingerprints < <(curl --silent -u "${CENSYS_API_ID}:${CENSYS_API_KEY}" "${uri}${search_string}" | jq -r '.result.hits[] | .fingerprint_sha256' 2>/dev/null)

      echo "${fingerprints[@]}"
      
}

get_certs_hosts(){

      local domain=$1

      local -a hosts

      for i in "${fingerprints[@]}"; do

            local uri="https://search.censys.io/api/v2/certificates/${i}/hosts"

            mapfile -t hosts < <(curl --silent -u "${CENSYS_API_ID}:${CENSYS_API_KEY}" "${uri}" | jq -r '.result | .hosts' 2>/dev/null)

            echo "${hosts[@]}"

      done

}

################################################################
################################################################

# CRT.SH SUBDOMAINS - GET ISSUED SSL HOSTS FROM DOMAIN NAME - IDENTICAL TO CENSYS FINGERPRINT SHA256 SSL CERT (NOT LIMITED | FREE)

get_subdomains(){

      local domain=$1

      local uri="https://crt.sh"

      local search_string="?q=${domain}&output=json"

      mapfile -t subdomains < <(curl --silent "${uri}${search_string}" | jq -r '.[] | .name_value, .common_name' 2>/dev/null | grep -oiPa "^([a-zA-Z0-9\-_]+\.)*${domain}$" | sort -u)

      echo "${subdomains[@]}"

}

get_ips(){

      for i in "${subdomains[@]}"; do

            mapfile -t -O "${#ips[@]}" ips < <(dig "${i}" +short | grep -iPam 1 "${ip_regex}") 

      done

      echo "${ips[@]}"

}

################################################################
################################################################

# SCRIPT OPTIONS

opt_parser(){

d_flag=false
s_flag=false
c_flag=false

d_value=""

while getopts ":hd:sc" opt; do

	case "${opt}" in

        d)  d_flag=true
            d_value=${OPTARG} ;;

        s)  s_flag=true ;;

        c)  c_flag=true ;;

		h)  help; exit ;;

		:)	echo; echo -e "     -${OPTARG}: Argument Required" >&2; help; exit 1 ;;

		\?)	echo; echo -e "     Error: Invalid Option" >&2; help; exit 1 ;;

	esac

done

}

################################################################
################################################################

# SCRIPT'S OUTPUT

main(){

# REGEX

ip_regex='\d{1,3}(\.\d{1,3}){3}'
domain_regex='([A-Za-z0-9\-_]+\.)*[A-Za-z0-9\-_]+\.[a-zA-Z]+\.?$'
cf_regex='.*[Cc]loudflare.*'

# CLOUDFLARE

cf_status="Not in CF CDN"
cf_proxy="Disabled"

# CENSYS

CENSYS_API_ID="64de311c-b142-4f84-8631-a35559e37adb"
CENSYS_API_KEY="YKLpsWGAKOt3tb4F47lGvks8baNuYezJ"

check_deps

if test -z "{d_value}" || ! "${d_flag}"; then

      banner
      echo; echo -e "     Error: Domain Name Required --> -d Option\n"
      echo -e "     Try -d Option with a Valid Domain Name\n"; exit 1

fi

ip_address=$(ping -c 1 "${d_value}" 2> /dev/null | grep -iPaom 1 "${ip_regex}")  # Obtain Origin Server or CF Ip Address

if $d_flag && [[ ${d_value} =~ $domain_regex ]] && ! test -z "${ip_address}"; then

    organization=$(curl --silent https://ipinfo.io/"${ip_address}"?fields=company | jq '. | .org' | grep -oiPa '"AS\d{1,9}\s\K.*(?=")') # Obtain Hosting Provider Name

    cloudflare=$(curl --silent https://ipinfo.io/"${ip_address}"?fields=company | jq '. | .org' | grep -iPa '.*cloudflare.*')

    asn=$(curl --silent https://ipinfo.io/"${ip_address}"?fields=company | jq '. | .org' | grep -oiPa '"\K.*(?=")' | grep -oiPa '^AS\d{1,9}')

    mapfile -t ns < <(dig "${d_value}" ns +short | grep -viaP '(^\d{1,3}(\.\d{1,3}){3})|(^\w{0,4}(:\w{0,4})+)') # Domain Nameservers Array

    mapfile -t mx < <(dig "${d_value}" mx +short | grep -viaP '(^\d{1,3}(\.\d{1,3}){3})|(^\w{0,4}(:\w{0,4})+)' | grep -oiPa '(?<=\d{2}\s).*') # Domain MX Array

    for i in "${mx[@]}"; do

        mapfile -t -O "${#mx_ip[@]}" mx_ip < <(dig "${i}" +short)

    done

    banner

    echo; echo -e "Summary:\n"
      echo -e "     Website Target  -->  ${d_value}\n"

    for i in "${ns[@]}"; do

        if [[ "${cloudflare}" =~ $cf_regex ]] && [[ "${i}" =~ $cf_regex ]]; then

                cf_proxy="Enabled"; cf_status="On CloudFlare CDN"

        elif test -z "${cloudflare}" && [[ "${i}" =~ $cf_regex ]]; then

                cf_status="On CloudFlare CDN"

        fi

    done

    echo -e "     Organization    -->  ${organization}\n"
    echo -e "     IP Address      -->  ${ip_address}\n"
    echo -e "     ASN             -->  ${asn}\n"
    echo -e "     Cloudflare      -->  ${cf_status}\n"
    echo -e "     CF Proxy        -->  ${cf_proxy}\n"

    c_ns=0; c_mx=0; c_mx_ip=0

    for i in "${ns[@]}"; do

        c_ns=$((c_ns+1))

        echo -e "     Nameserver${c_ns}     -->  ${i}\n"

    done

    for i in "${mx[@]}"; do

        c_mx=$((c_mx+1))

        for e in ${mx_ip[$c_mx_ip]}; do

            echo -e "     MX Server${c_mx}      -->  ${i} (${e})\n"

            c_mx_ip=$((c_mx_ip+1)); break

        done

    done

    if $s_flag; then

        get_subdomains "${d_value}" > /dev/null
        get_ips > /dev/null

        banner1

        echo -e " Subdomains:\n"

        c_ips=0

        for i in "${subdomains[@]}"; do

            for e in ${ips[${c_ips}]}; do

                #echo -e "     --> ${i}: ${e}\n"

                echo "     ╔══════════════════════════════════╦"
                echo -e "     ║  ${i}\n     ║  ${e}               " 
                echo "     ╚══════════════════════════════════╩" 

                c_ips=$((c_ips+1)); break

            done

            echo

        done

    fi

    if $c_flag; then

        get_subdomains "${d_value}" > /dev/null
        get_ips > /dev/null

        origin_ip_set=()
                  
        declare -A asociative_array

        get_subdomains "${d_value}" > /dev/null
        get_ips > /dev/null

        for i in "${ips[@]}"; do

            asociative_array["${i}"]=1

        done

        origin_ip_set+=("${!asociative_array[@]}")

        origin_ip_setf=$(echo "${origin_ip_set[@]}" | sed 's@ @ | @g')

        banner1

        echo -e " Origin IP Addresses Set:\n"

        echo -e "     $origin_ip_setf\n"

    fi

elif ! $d_flag && $s_flag || ! $d_flag && $c_flag ; then

    banner
    echo; echo -e "     Error: Domain Name Required --> -d Option\n"
    echo -e "     Try a Valid Domain Name\n"; exit 1

elif $d_flag && ! [[ ${d_value} =~ $domain_regex ]]; then

    banner
    echo; echo -e "     Error Type: Invalid Domain Name --> ${d_value}\n"
    echo -e "     Seems Wrong...\n"
    echo -e "     Try a Valid Domain Name\n"; exit 1

else

    banner
    echo; echo -e "     Error Type: Generic \n"
    echo -e "     Something Seems Wrong...\n"
    echo -e "     Try a Valid Domain Name or Check -h Option\n"; exit 1

fi

}

################################################################
################################################################

# FUNCTIONS' EXECUTION

opt_parser "${@}"

main

################################################################
################################################################

# PENDIENTE --> QUITAR DE ORIGIN IP ADDRESSES SET LAS DIRECCIONES IP DE CF, PARA UN MAYOR FILTRO

# https://ipinfo.io/"${IP_ADDRESS}"/json

# https://ipinfo.io/188.114.97.5?fields=company

# https://get.geojs.io/v1/ip/country/"${IP_ADDRESS}"

# PENDIENTE --> INTEGRAR https://hackertarget.com/ip-tools/ --> 50 API CALLS / DAY --> NOT API AUTHENTICATION (LIMIT APPLIED BY IP - MAYBE CAN BYPASS IP RESTRICTION
#                                                               CHANGING IP SOURCE API REQUESTS IF POSSIBLE)

# PENDIENTE --> USAR HTTPPROBE PARA PROBAR PUERTO 80 443 8443 de los subdominios

# CLOUDPELER --> https://github.com/zidansec/CloudPeler/tree/master

# CF BYPASS --> https://scrapeops.io/web-scraping-playbook/how-to-bypass-cloudflare/

# CONSIDERATIONS TO IMPLEMENT ON THIS TOOL --> https://samanpavel.medium.com/finding-out-subdomains-64469cbfef52

#                                              https://github.com/pavelsaman/scripts-backup/blob/master/subdomains/subdomains.sh

# USE --LONG OPTIONS TO DO SCRIPT MORE READABLE

# STORAGE ALL INSIDE FUNCTIONS AND CALL THESE FUNCTIONS AFTER WITH A MAIN FUNCTION

               
                                                                    