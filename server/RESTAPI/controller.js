const db = require("../mysql.js");
const addr = require("./cosnt/address.js");
const signUp = require("./request/signUp.js");
const logIn = require("./request/logIn.js");
const tableSearch = require("./request/tableSearch.js");
const addBook = require("./request/addBook.js");
const tableAdd = require("./request/tableAdd.js");
const myTable = require("./request/myTable.js");
const regidBooks = require("./request/regidBooks.js");
const logOut = require("./request/logOut.js");
const delMyTable = require("./request/delMyTable.js");
const personInfo = require("./request/personInfo.js");
const removeBook = require("./request/removeBook.js");
const notify = require("./request/notify.js");
const notBox = require("./request/notBox.js");
const delNotBox = require("./request/delNotBox.js");
function controller(targetUrl, body, sessionID, response) {
  /* mapping each url to appropriate function */
  const sendTo = new Map([
    [addr.signUpURL, signUp.request],
    [addr.logInURL, logIn.request],
    [addr.splashURL, signUp.request],
    [addr.personInfoURL, personInfo.request],
    [addr.logOutURL, logOut.request],
    [addr.tableSearchURL, tableSearch.request],
    [addr.tableAddURL, tableAdd.request],
    [addr.myTableURL, myTable.request],
    [addr.delMyTableURL, delMyTable.request],
    [addr.addBookURL, addBook.request],
    [addr.regidBooksURL, regidBooks.request],
    [addr.removeBookURL, removeBook.request],
    [addr.notifyURL, notify.request],
    [addr.notBoxURL, notBox.request],
    [addr.delMyTableURL, delNotBox.request],
  ]);

  if (sessionID == "login" || sessionID == "signup") {
    console.log(`>> controller.js >> this is for login or signup `);
    sendTo.get(targetUrl)(body, response);
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
