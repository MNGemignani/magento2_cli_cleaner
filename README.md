# Magento 2 cleaner commands

  This commands were created to help speed up development with Magento 2, removing folders, compiling and giving the right permissions with one single command.

### Installation:
 
 You can add the scripts from this repo in different ways, an example is: 
  
    Add `clm2.sh` in the magento2 root directory, and run `$ chmod +x clm2.sh` to make it executable.
 
 
### Usage: 
  
  Run `$ ./clm2.sh -[command]` (from the directory where the file is, or add the file to your PATH, or to a `bin` folder in your `home` directory).
  
  
### Possible Commands:

    Add the letters after '-' to run the commands (will run the order you add it)
    
    c       Clean the cache

    s       Clean static folder
    
    r       Remove all generated files and re-compiles
    
    u       Run setup:upgrade
    
    i       Run indexer:reindex
            
    With you want to run all commands just use:
    
    --all   Same as -csuri
              
              
### Example
              
        Clear all static files: clm2.sh -s"
        
        Clear all static files, clear cache and recompile: clm2.sh -csr"

### Information:

  For help and all available commands run `$ ./clm2.sh --help`.
  