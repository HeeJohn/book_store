const db = require("../../../mysql.js");

function request(body, response) {

  console.log(`>> login.js >> data :  ${body}`);
  //----> sql
  let targetTable = 'USER';
  let sql = `SELECT * FROM ${targetTable} WHERE PHONE = ? AND PASSWORD = ?;`;
  let param = [body.phone, body.password];

  db.query(sql, param, function (error, result) {
    if (error) {
      console.log(error.code);
      console.log(`>> login.js >> ${error}`);
      response.end(JSON.stringify({ "message": "duplicated" }));
      return;
    } else { /* ------ login success get insert session -------- */
  
      if (result.length == 0 || result[0] == undefined) {
        response.end(JSON.stringify({ 'message': 'no user' }));
        return;
      }
     
      //----> sql
      let targetTable = 'SESSION';
      let sql = `INSERT INTO ${targetTable}(student_id) VALUES(?);`;
      let param = [result[0].student_id];

      db.query(sql, param, function (error, insert_result) {
        if (error) {
          if (error.code == 'ER_DUP_ENTRY') {
            console.log(`>> login.js >> insert student id`);
            console.log(error);
            response.end(JSON.stringify({ "message": "duplicated" }));
            return;
          }
        } else { /* ------ session id created successfully -------- */
          //----> sql
          let sql = `SELECT session_id FROM ${targetTable} WHERE STUDENT_ID = ?;`;
          console.log(`>> login.js >> select session Id`);
          db.query(sql, param, function (error, result) {
            if (error) {
              switch (error.code) {
                case 'ER_DUP_ENTRY': console.log(error);
                  console.log(`>> login.js >> falied to insert session id`);
                  response.end(JSON.stringify({ "message": "duplicated" }));
                  return;
              }
            } else {
              response.writeHead(200);
              response.end(JSON.stringify({ 'message': 'login done', 'session_id': result[0].session_id }));
              return;
            }
          }
          );
        }
      }
      );
    }
  }
  );
}

module.exports = { request };
