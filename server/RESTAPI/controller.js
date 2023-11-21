const db = require("../mysql.js");
const addr = require("./cosnt/address.js");
const signUp = require("./request/signUp.js");
const logIn = require("./request/logIn.js");
function controller(targetUrl, body, sessionID, response) {
    
  /* mapping each url to appropriate function */
  const sendTo = new Map([
    [addr.signUpURL, signUp.request],
    [addr.logInURL, logIn.request],
    [addr.splashURL, signUp.request],
    [addr.gpsURL, signUp.request],
    [addr.tableSearchURL, signUp.request],
    [addr.tableAddURL, signUp.request],
    [addr.myTableURL, signUp.request],
  ]);

  // check sessionID
  let sql = `SELECT STUDENT_ID 
            FROM SESSION
            WHERE id = ?`;
  let param = [sessionID];
  db.query(sql, param, function (error, id) {
    if (error) {
      sendTo.get(targetUrl)(body, response);
    } else {
      console.log(id);
      sendTo.get(targetUrl)(id, body, response);
    }
  });
}

module.exports = { controller };
