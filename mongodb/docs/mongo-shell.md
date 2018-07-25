# mongo Shell Quick Reference 快速参考
## mongo Shell Command History
> ~/.dbshell

## Command Line Options
## Command Helpers
help	                 # Show help.
db.help()	             # Show help for database methods.
db.<collection>.help() # Show help on collection methods. The <collection> can be the name of an existing collection or a non-existing collection.
show dbs	             # Print a list of all databases on the server.
use <db>	             # Switch current database to <db>. The mongo shell variable db is set to the current database.
show collections	     # Print a list of all collections for current database
show users	           # Print a list of users for current database.
show roles      	     # Print a list of all roles, both user-defined and built-in, for the current database.
show profile	         # Print the five most recent operations that took 1 millisecond or more. See documentation on the database profiler for more information.
show databases	       # Print a list of all available databases.
load()	               # Execute a JavaScript file. See Write Scripts for the mongo Shell for more information.

## Basic Shell JavaScript Operations
## Keyboard Shortcuts
## Queries
## Error Checking Methods
## Administrative Command Helpers
## Opening Additional Connections
## Miscellaneous
## Additional Resources
