cmdCount = 1;
host = db.serverStatus().host;
// prompt = function() {
//              return (cmdCount++) + "> ";
//          }
// prompt = function() {
//             return db+"@"+host+"$ ";
//         }
prompt = function() {
          return host+"@"+db+" "+"Uptime:"+db.serverStatus().uptime+" Documents:"+db.stats().objects+" > ";
        }
