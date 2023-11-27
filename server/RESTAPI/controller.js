const db = require("../mysql.js");
const addr = require("./cosnt/address.js");
const signUp = require("./request/signUp.js");
const logIn = require("./request/logIn.js");
const tableSearch = require("./request/tableSearch.js");
const addBook = require("./request/addBook.js");
const tableAdd = require("./request/tableAdd.js");
const myTable = require("./request/myTable.js");

function controller(targetUrl, body, sessionID, response) {
  /* mapping each url to appropriate function */
  const sendTo = new Map([
    [addr.signUpURL, signUp.request],
    [addr.logInURL, logIn.request],
    [addr.splashURL, signUp.request],
    [addr.gpsURL, signUp.request],
    [addr.tableSearchURL, tableSearch.request],
    [addr.tableAddURL, tableAdd.request],
    [addr.myTableURL, myTable.request],
    [addr.addBookURL, addBook.request],
  ]);
  if (sessionID == "login" || sessionID == "signup") {
    console.log(`>> controller.js >> this is for login or signup `);
    sendTo.get(targetUrl)(body, response);
    sessionID = null;
  } else {
    // check sessionID
    console.log(`>> controller.js >> this is for session parsing `);
    let sql = `SELECT STUDENT_ID FROM SESSION WHERE SESSION_ID = ?`;
    let param = [sessionID];
    db.query(sql, param, function (error, id) {
      if (error) {
        response.writeHead(200);
        response.end(JSON.stringify({'message' : 'wrong access'}));
      } else {
        const studentId = id[0].STUDENT_ID; // Extract student_id
        console.log(`>> controller.js >> student_id :  ${studentId}`);
        sendTo.get(targetUrl)(studentId, body, response);
      }
    });
  }
}

module.exports = { controller };
