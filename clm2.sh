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
    printf "${green}Remcompiled${NC}\n"

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
    echo "${bold}NAME${normal}"
    echo
    echo "      clm2 <Commands>"
    echo
    echo
    echo "${bold}DESCRIPTION${normal}"
    echo
    echo "      -a, --clean-all"
    echo
    echo "              Remove all generated files (cache and classes) and re-compiles"
    echo
    echo "      -au, --clean-all-upgrade"
    echo
    echo "              Remove all generated files (cache and classes), run setup:upgrade and re-compiles"
    echo
    echo "      -ai, --clean-all-reindex"
    echo
    echo "              Remove all generated files (cache and classes), run indexer:reindex and re-compiles"
    echo
    echo "      -aui, --clean-all-upgrade-reindex"
    echo
    echo "              Remove all generated files (cache and classes), run setup:upgrade, run indexer:reindex and re-compiles"
    echo
    echo "      -c, --compile"
    echo
    echo "              Remove all generated files (classes) from magento2.0 and 2.1 and re-compiles"
    echo
    echo
    echo "      -s, --clean-static"
    echo
    echo "              Remove all static files (js and cache) from magento2"
    echo
    echo "${bold}EXAMPLE${normal}"
    echo
    echo "      Clear all static files: clm2 -s"
    echo
    echo "      OR"
    echo
    echo "      Clear all static files: clm2 --clean-static"
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
