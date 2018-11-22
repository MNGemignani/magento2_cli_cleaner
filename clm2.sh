#!/usr/bin/env bash

clm2 () {
bold=$(tput bold)
normal=$(tput sgr0)
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
NC='\033[0m'
    if [ "$1" == "-a" ] || [ "$1" == "--clean-all" ]; then
        echo
        printf "${green}Cleaning all the shits from Magento...${NC}\n"
        echo
        sudo rm -rf pub/static/*
        sudo rm -rf var/generation/*
        sudo rm -rf var/cache/
        sudo rm -rf var/page_cache/
        sudo rm -rf var/view_preprocessed/
        sudo php bin/magento setup:di:compile
        sudo php bin/magento cache:flush
        sudo chmod 777 -R *
        echo
        printf "${green}All done!${NC}\n"
        echo

    elif [ "$1" == "-a2" ] || [ "$1" == "--clean-all2" ]; then
        echo
        printf "${green}Cleaning all the shits from Magento 2.2 or higher...${NC}\n"
        echo
        sudo rm -rf pub/static/*
        sudo rm -rf generated/*
        sudo rm -rf var/cache/
        sudo rm -rf var/page_cache/
        sudo rm -rf var/view_preprocessed/
        sudo php bin/magento setup:di:compile
        sudo php bin/magento cache:flush
        sudo chmod 777 -R *
        echo
        printf "${green}All done!${NC}\n"
        echo

    elif [ "$1" == "-c" ] || [ "$1" == "--compile" ]; then
        echo
        printf "${green}Compiling Magento...${NC}\n"
        echo
        sudo rm -rf var/generation/*
        sudo php bin/magento setup:di:compile
        sudo php bin/magento cache:flush
        sudo chmod 777 -R *
        echo
        printf "${green}Compiled!${NC}\n"
        echo

    elif [ "$1" == "-c2" ] || [ "$1" == "--compile2" ]; then
        echo
        printf "${green}Compiling Magento 2.2 or higher...${NC}\n"
        echo
        sudo rm -rf generated/*
        sudo php bin/magento setup:di:compile
        sudo php bin/magento cache:flush
        sudo chmod 777 -R *
        echo
        printf "${green}Compiled!${NC}\n"
        echo

    elif [ "$1" == "-s" ] || [ "$1" == "--clean-static" ]; then
        echo
        printf "${green}Removing Magento static files...${NC}\n"
        echo
        sudo rm -rf pub/static/*
        sudo rm -rf var/cache/
        sudo rm -rf var/page_cache/
        sudo rm -rf var/view_preprocessed/
        sudo php bin/magento cache:flush
        sudo chmod 777 -R *
        echo
        printf "${green}All clean!${NC}\n"
        echo

    elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo
        echo "${bold}NAME${normal}"
        echo
        echo "      clm2 <Commands>"
        echo
        echo
        echo "${bold}DESCRIPTION${normal}"
        echo
        echo "      Possible commands:"
        echo
        echo "              -a, --clean-all | -a2, --clean-all2 | -c, --compile | -c2, --compile2 | -s, --clean-static "
        echo
        echo "      -a, --clean-all"
        echo
        echo "              Remove all generated files (cache and classes) from magento2.0 and 2.1 and re-compiles"
        echo
        echo "      -a2, --clean-all2"
        echo
        echo "              Remove all generated files (cache and classes) from magento2.2 (and higher) and re-compiles"
        echo
        echo "      -c, --compile"
        echo
        echo "              Remove all generated files (classes) from magento2.0 and 2.1 and re-compiles"
        echo
        echo "      -c2, --compile2"
        echo
        echo "              Remove all generated files (classes) from magento2.2 (and higher) and re-compiles"
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
        echo "${bold}NOTES${normal}"
        echo
        echo "      If your Magento2 version is 2.2 or higher you need to add a 2 in front of -a (--clean-all) and -c (--compile) commands"
        echo
        echo "Your current magento 2 version is: "
        echo
        sudo php bin/magento -V
        echo
    else
        echo
        printf "${green}You need to choose a command: --clean-all | --clean-all2 | --compile | --compile2 | --clean-static ${NC}\n"
        echo
        printf "${green}Or one of the short cuts: -a | -a2 | -c | -c2 | -s ${NC}\n"
        echo
        printf "${yellow}If you need help type: clm2 --help or -h${NC}\n"
        echo
        printf "${red}If your Magento2 version is 2.2 or higher you need to add a 2 in front of -a and -c commands${NC}\n"
        echo
        echo "Your current magento 2 version is: "
        echo
        sudo php bin/magento -V
        echo
    fi
}
