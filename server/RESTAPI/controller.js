const db = require("../mysql.js");
const addr = require("./cosnt/address.js");
const signUp = require("./request/auth/signUp.js");
const logIn = require("./request/auth/logIn.js");
const tableSearch = require("./request/table/tableSearch.js");
const addBook = require("./request/regidBook/addBook.js");
const tableAdd = require("./request/table/tableAdd.js");
const myTable = require("./request/table/myTable.js");
const regidBooks = require("./request/regidBook/regidBooks.js");
const logOut = require("./request/auth/logOut.js");
const delMyTable = require("./request/table/delMyTable.js");
const personInfo = require("./request/auth/personInfo.js");
const removeBook = require("./request/regidBook/removeBook.js");
const notify = require("./request/note/notify.js");
const notBox = require("./request/note/notBox.js");
const delNotBox = require("./request/note/delNotBox.js");
const updateNotBox = require("./request/note/updateNotBox.js");
const readMeeting = require("./request/meet/readMeeting.js");
const searchBooks = require("./request/regidBook/searchBook.js");
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
    [addr.delNotBoxURL, delNotBox.request],
    [addr.updateNotBoxURL, updateNotBox.request],
    [addr.readMeetingURL, readMeeting.request],
    [addr.searchBooksURL, searchBooks.request],
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
        return;
      } else {
        if(id.length ===0 || id[0]===undefined){
          console.log(`>> controller.js >> student_id :  ${id}`);
          response.end(JSON.stringify({'message' : 'no data'}));
          return;
        }
        console.log(id);
        const studentId = id[0].STUDENT_ID; // Extract student_id
        console.log(`>> controller.js >> student_id :  ${studentId}`);
        sendTo.get(targetUrl)(studentId, body, response);
        return;
      }
    });
  }
}

module.exports = { controller };
