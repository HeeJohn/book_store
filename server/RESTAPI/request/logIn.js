const db = require("../../mysql.js");

function request(body, response) {

  console.log(`>> login.js >> data :  ${body}`);
  //----> sql
  let targetTable = 'USER';
  let sql = `SELECT * FROM ${targetTable} WHERE PHONE = ? AND PASSWORD = ?;`;
  let param =  [body.phone, body.password];

  db.query(sql, param, function (error, result) {
      if (error) {
        console.log(error);
        console.log(`>> login.js >> login faield id`);
        response.writeHead(404);
        response.end(JSON.stringify({"message": "failed to login"}));
      } else { /* ------ login success get insert session -------- */
     
        //----> sql
        let targetTable = 'SESSION';
        let sql =`INSERT INTO ${targetTable}(student_id) VALUES(?);`;
        let param =  [result[0].student_id];

        db.query(sql, param, function (error, insert_result) {
          if(error){
            if (error.code= 'ER_DUP_ENTRY') {
              console.log(`>> login.js >> insert student id`);
              console.log(error);
              response.end(JSON.stringify({"message": "duplicated"}));
            }
          } else { /* ------ session id created successfully -------- */
            //----> sql
            let sql = `SELECT session_id FROM ${targetTable} WHERE STUDENT_ID = ?;`;
              console.log(`>> login.js >> select session Id`);
              db.query( sql, param, function (error, result) {
                  if (error) {
                    console.log(error);
                    response.writeHead(404);
                    response.end(JSON.stringify({"message": "failed to get created session"}));
                  } else {
                    response.writeHead(200);
                    response.end(JSON.stringify({'message':'login done', 'session_id' :result[0].session_id})); 
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
