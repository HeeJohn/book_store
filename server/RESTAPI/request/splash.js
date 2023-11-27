const db = require("../../mysql.js");

function request(body, response) {
  console.log(`>> splash.js >> data :  ${body}`);
  //----> sql
  let sql = `SELECT * FROM ? WHERE PHONE = ? AND PASSWORD = ?`;
  let targetTable = 'user';
  let param =  [targetTable, body.phone, body.password];

  db.query(sql, parma, function (error, result) {
      if (error) {
        console.log(error);
        result.writeHead(404);
        response.end(JSON.stringify({"message": "failed to login"}));
      } else { /* ------ login success get insert session -------- */

        //----> sql
        let sql =`INSERT INTO ? (student_id) VALUES(?)`;
        let targetTable = 'SESSION';
        let param =  [targetTable, result.student_id];

        db.query(sql, param, function (error, insert_result) {
            if (error) {
              console.log(error);
              result.writeHead(404);
              response.end(JSON.stringify({"message": "failed to create session"}));
            } else { /* ------ session id created successfully -------- */
            
            //----> sql
            let sql = `SELECT session_id FROM ? WHERE STUDENT_ID = ?`;
            let targetTable = 'SESSION';
            let param =  [targetTable, result.student_id];

              db.query( sql, param, function (error, result) {
                  if (error) {
                    console.log(error);
                    result.writeHead(404);
                    response.end(JSON.stringify({"message": "failed to get created session"}));
                  } else {
                    response.writeHead(200);
                    response.end(JSON.stringify(result));
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
