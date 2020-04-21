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

checkHasSlash () {

    if [[ !("$1" == "-") ]]  || [[ "$1" == "" ]]
    then
        printErrorMessage
        exit 1
    fi

}

checkParameter () {

    if [[ !(${PARAMETER} =~ .*-.*) ]]
    then
       printErrorMessage
       exit 1
    fi

}

printStartMessage () {

    echo
    printf "${green}Let's starts!${NC}\n"
    echo
}

printEndMessage () {

    echo
    printf "${green}All done!${NC}\n"
    echo

}

clearStatic () {

    rm -rf pub/static/*
    checkExitStatus
    printf "${green}Clearing static folder complete${NC}\n"

}

recompile () {

    rm -rf generated/
    checkExitStatus
    php bin/magento setup:di:compile
    checkExitStatus
    printf "${green}Recompiled${NC}\n"

}

upgrade () {

    php bin/magento setup:upgrade
    checkExitStatus
    printf "${green}Upgraded${NC}\n"

}

reindex () {

    php bin/magento indexer:reindex
    checkExitStatus
    printf "${green}Reindexed${NC}\n"

}

clearCache () {

    rm -rf var/cache/ && rm -rf var/page_cache/ && rm -rf var/view_preprocessed/
    checkExitStatus
    printf "${green}Clearing cache complete${NC}\n"

}

checkExitStatus () {

    retVal=$?
    if [[ $retVal -ne 0 ]]; then
        printf "${red}Something went wrong${NC}\n"
        exit $retVal
    fi

}

givePermissions () {

    chmod 777 -R *
    checkExitStatus

}

printHelpMessage () {

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

printErrorMessage () {

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

cleanAll () {

    clearCache
    clearStatic
    upgrade
    recompile
    reindex
    givePermissions

}

staticContentDeploy () {

    bin/magento static:content:deploy "$1"
    checkExitStatus
    echo
    printf "${green}Finish static content deploy for $1${NC}\n"

}

givePermissionsProd () {

    find ./var -type d -exec chmod 777 {} \ && find ./pub/media -type d -exec chmod 777 {} \ && find ./pub/static -type d -exec chmod 777 {} \
    chmod 777 ./app/etc && chmod 644 ./app/etc/*.xml
    checkExitStatus

}

productionMode () {

    if [[ "$PARAMETER2" == "" ]]; then

        printErrorMessage
        exit 1

    fi

    #Start process
    bin/magento maintenance:enabled
    checkExitStatus
    clearCache
    clearStatic

    if [[ ${PARAMETER3} =~ .*u.* ]]
    then
        upgrade
        checkExitStatus
    fi

    recompile

    for (( i=0; i<${#PARAMETER2}; i+=3 )); do

        clearCache
        local p1=${PARAMETER2:$i:2}
        case ${p1,,} in

            nl)
                staticContentDeploy "nl_NL"
                ;;

            en)
                staticContentDeploy "en_EN"
                clearCache
                staticContentDeploy "en_GB"
                ;;

            de)
                staticContentDeploy "de_DE"
                ;;

            *)
                echo "This parameter doesn't match any available country code: ${PARAMETER:$i:2}"
                echo "Current available country codes: nl, en, de (case doesn't matter)"
                ;;
            esac


    done

    clearCache

    if [[ ${PARAMETER3} =~ .*i.* ]]
    then
        reindex
        checkExitStatus
    fi

    bin/magento maintenance:disable
    givePermissionsProd

    printEndMessage

}

main () {
    if [[ "$PARAMETER" == "" ]]
    then
        printErrorMessage
        exit 1
    fi

    printStartMessage

    for (( i=0; i<${#PARAMETER}; i++ )); do
        if [[ "$i" == 0 ]]; then

            checkHasSlash "${PARAMETER:$i:1}"

        elif [[ "$i" == 1 ]] && [[ "${PARAMETER:$i:1}" == "-" ]] && [[ "${PARAMETER}" == "--help" ]]; then

            printHelpMessage
            exit 0

        elif [[ "$i" == 1 ]] && [[ "${PARAMETER:$i:1}" == "-" ]] && [[ "${PARAMETER}" == "--all" ]]; then

            cleanAll
            exit 0

        elif [[ "$i" == 1 ]] && [[ "${PARAMETER:$i:1}" == "-" ]] && [[ "${PARAMETER}" == "--p" ]]; then

            productionMode
            exit 0

        else

            case ${PARAMETER:$i:1} in

                c)
                    #Clear the cache
                    clearCache
                    ;;

                s)
                    #Clear static folder
                    clearStatic
                    ;;

                u)
                    #Upgrade
                    upgrade
                    ;;

                r)
                    #Recompile
                    recompile
                    ;;

                i)
                    #Reindex
                    reindex
                    ;;

                *)
                    echo "This parameter doesn't do nothing: ${PARAMETER:$i:1}"
                    ;;
            esac

            givePermissions
        fi
    done
    printEndMessage

}

main
