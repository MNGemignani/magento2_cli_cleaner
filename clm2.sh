#! /bin/bash

# Style variables
bold=$(tput bold)
normal=$(tput sgr0)
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
NC='\033[0m'
# End Style variables

PARAMETER=$1
PARAMETER2=$2
PARAMETER3=$3

_checkHasSlash () {

    if [[ !("$1" == "-") ]]  || [[ "$1" == "" ]]
    then
        _printErrorMessage
        exit 1
    fi

}

_checkParameter () {

    if [[ !(${PARAMETER} =~ .*-.*) ]]
    then
       _printErrorMessage
       exit 1
    fi

}

_printStartMessage () {

    echo
    printf "${green}Let's starts!${NC}\n"
    echo
}

_printEndMessage () {

    echo
    printf "${green}All done!${NC}\n"
    echo

}

_checkExitStatus () {

    retVal=$?
    if [[ $retVal -ne 0 ]]; then
        printf "${red}Something went wrong${NC}\n"
        exit $retVal
    fi

}

_clearStatic () {

    rm -rf pub/static/*
    _checkExitStatus
    printf "${green}Clearing static folder complete${NC}\n"

}

_recompile () {

    rm -rf generated/
    _checkExitStatus
    php bin/magento setup:di:compile
    _checkExitStatus
    printf "${green}Recompiled${NC}\n"

}

_upgrade () {

    php bin/magento setup:upgrade
    _checkExitStatus
    printf "${green}Upgraded${NC}\n"

}

_reindex () {

    php bin/magento indexer:reindex
    _checkExitStatus
    printf "${green}Reindexed${NC}\n"

}

_clearCache () {

    rm -rf var/cache/ && rm -rf var/page_cache/ && rm -rf var/view_preprocessed/
    _checkExitStatus
    printf "${green}Clearing cache complete${NC}\n"

}

_givePermissions () {

    chmod 777 -R *
    _checkExitStatus

}

_printHelpMessage () {

    echo
    echo "${bold}USAGE${normal}"
    echo
    echo "      clm2 -<COMMAND><COMMAND>"
    echo
    echo "      clm2 --all"
    echo
    echo "      clm2 --p -<COUNTRY_CODE>,<COUNTRY_CODE> -<COMMAND><COMMAND>"
    echo
    echo "      clm2 --help"
    echo
    echo
    echo "${bold}DESCRIPTION${normal}"
    echo
    echo "      Add the letters after '-' to run the commands"
    echo
    echo "      ${bold}c${normal}"
    echo
    echo "              Clean cache"
    echo
    echo "      ${bold}s${normal}"
    echo
    echo "              Clean static folder"
    echo
    echo "      ${bold}r${normal}"
    echo
    echo "              Remove all generated files and re-compiles"
    echo
    echo "      ${bold}u${normal}"
    echo
    echo "              Run setup:upgrade"
    echo
    echo "      ${bold}i${normal}"
    echo
    echo "              Run indexer:reindex"
    echo
    echo "      If you want to run all commands just use:"
    echo
    echo "      ${bold}--all${normal}"
    echo
    echo "      For production mode you can you need to start with --p and pass second parameter the country code separated by coma"
    echo "      You can also add -i , -u or -iu to run setup:upgrade and indexer:reindex"
    echo
    echo "      ${bold}--p -<COUNTRY_CODE>,<COUNTRY_CODE> -<COMMAND>${normal}"
    echo
    echo "      ${bold}<COUNTRY_CODE>${normal}"
    echo "              Is the country code to run the static content deploy, separeted by comma, current support:"
    echo "              - nl => nl_NL"
    echo "              - en => en_EN and en_GB"
    echo "              - de => de_DE"
    echo
    echo "${bold}EXAMPLE${normal}"
    echo
    echo "      Clear all static files: clm2 -s"
    echo
    echo "      Clear all static files, clear cache and recompile: clm2 -csr"
    echo
    echo "      Production mode run static content for en_EN and nl_NL and reindex; clm2 --p -nl,en -i"
    echo
    echo "${bold}AUTHOR${normal}"
    echo
    echo "      Written by Mateus Gemignani"
    echo
    printf "${red}Your current magento 2 version is: ${NC}\n"
    echo
    php bin/magento -V
    echo

}

_printErrorMessage () {

    echo
    printf "${green}Missing parameter${NC}\n"
    echo
    printf "${yellow}If you need help type: clm2 --help${NC}\n"
    echo
    printf "${red}Your current magento 2 version is: ${NC}\n"
    echo
    php bin/magento -V
    echo

}

_cleanAll () {

    _clearCache
    _clearStatic
    _upgrade
    _recompile
    _reindex
    _givePermissions

}

_staticContentDeploy () {

    php bin/magento static:content:deploy "$1"
    _checkExitStatus
    echo
    printf "${green}Finish static content deploy for $1${NC}\n"

}

_givePermissionsProd () {

    find ./var -type d -exec chmod 777 {} \ && find ./pub/media -type d -exec chmod 777 {} \ && find ./pub/static -type d -exec chmod 777 {} \
    chmod 777 ./app/etc && chmod 644 ./app/etc/*.xml
    _checkExitStatus

}

_productionMode () {

    if [[ "$PARAMETER2" == "" ]]; then

        _printErrorMessage
        exit 1

    fi

    #Start process
    php bin/magento maintenance:enabled
    _checkExitStatus
    _clearCache
    _clearStatic

    if [[ ${PARAMETER3} =~ .*u.* ]]
    then
        _upgrade
        _checkExitStatus
    fi

    _recompile

    for (( i=0; i<${#PARAMETER2}; i+=3 )); do

        _clearCache
        local p1=${PARAMETER2:$i:2}
        case ${p1,,} in

            nl)
                _staticContentDeploy "nl_NL"
                ;;

            en)
                _staticContentDeploy "en_EN"
                _clearCache
                _staticContentDeploy "en_GB"
                ;;

            de)
                _staticContentDeploy "de_DE"
                ;;

            *)
                echo "This parameter doesn't match any available country code: ${PARAMETER:$i:2}"
                echo "Current available country codes: nl, en, de (case doesn't matter)"
                ;;
            esac


    done

    _clearCache

    if [[ ${PARAMETER3} =~ .*i.* ]]
    then
        _reindex
        _checkExitStatus
    fi

    php bin/magento maintenance:disable
    _givePermissionsProd

    _printEndMessage

}

main () {
    if [[ "$PARAMETER" == "" ]]
    then
        _printErrorMessage
        exit 1
    fi

    _printStartMessage

    for (( i=0; i<${#PARAMETER}; i++ )); do
        if [[ "$i" == 0 ]]; then

            _checkHasSlash "${PARAMETER:$i:1}"

        elif [[ "$i" == 1 ]] && [[ "${PARAMETER:$i:1}" == "-" ]] && [[ "${PARAMETER}" == "--help" ]]; then

            _printHelpMessage
            exit 0

        elif [[ "$i" == 1 ]] && [[ "${PARAMETER:$i:1}" == "-" ]] && [[ "${PARAMETER}" == "--all" ]]; then

            _cleanAll
            exit 0

        elif [[ "$i" == 1 ]] && [[ "${PARAMETER:$i:1}" == "-" ]] && [[ "${PARAMETER}" == "--p" ]]; then

            _productionMode
            exit 0

        else

            case ${PARAMETER:$i:1} in

                c)
                    #Clear the cache
                    _clearCache
                    ;;

                s)
                    #Clear static folder
                    _clearStatic
                    ;;

                u)
                    #Upgrade
                    _upgrade
                    ;;

                r)
                    #Recompile
                    _recompile
                    ;;

                i)
                    #Reindex
                    _reindex
                    ;;

                *)
                    echo "This parameter doesn't do nothing: ${PARAMETER:$i:1}"
                    ;;
            esac

            _givePermissions
        fi
    done
    _printEndMessage

}

# Run command
main
