#! /bin/bash

# Styles variables
bold=$(tput bold)
normal=$(tput sgr0)
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
NC='\033[0m'
PARAMETER=$1

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

clm2 () {

    if [ "$PARAMETER" == "-a" ] || [ "$PARAMETER" == "--clean-all" ]; then

        printStartMessage
        clearCache
        clearStatic
        recompile
        givePermissions
        printEndMessage

    elif [ "$PARAMETER" == "-au" ] || [ "$PARAMETER" == "--clean-all-upgrade" ]; then

        printStartMessage
        clearCache
        clearStatic
        upgrade
        recompile
        givePermissions
        printEndMessage

    elif [ "$PARAMETER" == "-ai" ] || [ "$PARAMETER" == "--clean-all-reindex" ]; then

        printStartMessage
        clearCache
        clearStatic
        reindex
        recompile
        givePermissions
        printEndMessage

    elif [ "$PARAMETER" == "-aui" ] || [ "$PARAMETER" == "--clean-all-upgrade-reindex" ]; then

        printStartMessage
        clearCache
        clearStatic
        upgrade
        recompile
        reindex
        givePermissions
        printEndMessage

    elif [ "$PARAMETER" == "-c" ] || [ "$PARAMETER" == "--compile" ]; then

        printStartMessage
        clearCache
        recompile
        givePermissions
        printEndMessage


    elif [ "$PARAMETER" == "-s" ] || [ "$PARAMETER" == "--clean-static" ]; then

        printStartMessage
        clearStatic
        clearCache
        givePermissions
        printEndMessage

    elif [ "$PARAMETER" == "--help" ] || [ "$PARAMETER" == "-h" ]; then

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
    else
        echo
        printf "${green}You need to choose a command${NC}\n"
        echo
        printf "${yellow}If you need help type: clm2 --help${NC}\n"
        echo
        printf "${red}Your current magento 2 version is: ${NC}\n"
        echo
        php bin/magento -V
        echo
    fi
}

clm2