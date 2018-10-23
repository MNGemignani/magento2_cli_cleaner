# Magento 2 cleaner commands

  This commands were created to help speed up development with magento2, removing folders, compiling and giving the right permissions with one single command.

### Installation:
 
 You can add the scripts from this repo in different ways, I will give you two basic ones. 
 
 1) Add the function from `clm2.sh` (so without `#!/usr/bin/env bash`) to the end of your `.bashrc` file (you can find this file in your home directory) and after saving it, run `$ source .bashrc`.
 
 2) Add `clm2` in the magento2 root directory, and run `$ chmod +x clm2` to make it executable.
 
 
### Usage: 

  1)  If you install using the first option, just run `$ clm2 [command]` and the script will do the rest.
  
  2)  For the second option you need to run `$ ./clm2 [command]` (from the directory where the file is, or add the file to your PATH, or to a `bin` folder in your `home` directory).
  
  
### Possible Commands:

      Possible commands: -a, --clean-all | -a2, --clean-all2 | -c, --compile | -c2, --compile2 | -s, --clean-static 

      -a, --clean-all

              Remove all generated files (cache and classes) from magento2.0 and 2.1 and re-compiles

      -a2, --clean-all2

              Remove all generated files (cache and classes) from magento2.2 (and higher) and re-compiles

      -c, --compile

              Remove all generated files (classes) from magento2.0 and 2.1 and re-compiles

      -c2, --compile2

              Remove all generated files (classes) from magento2.2 (and higher) and re-compiles

      -s, --clean-static

              Remove all static files (js and cache) from magento2
      -h, --help
      
              Basic usage from this commands        

### Example:

  Clear all static files: `clm2 -s` OR `clm2 --clean-static`

### Information:

  For help and all available commands run `$ clm2 --help` or `$ ./clm2 --help`.
  
  For Magento versions 2.2 or higher you need to add a 2 in the end of the --compile(-c) and --clean-all(-a) commands. 
  
  Please do not expect any help or bug fixing from me, this is only a trial script for learning proposes. I'm always open for tips or improvements in my code.
