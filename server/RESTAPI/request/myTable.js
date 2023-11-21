const db = require('../../mysql.js');


function request(body, response) {

  //----> sql
  let targetTable= 'user';
  let sql = `INSERT INTO ${targetTable} (phone, name, student_id, password) VALUES (?, ?, ?, ?);`;
  let param = [body.phone, body.name, body.id, body.password];
  db.query(sql, param, function (error, result) {
      if (error) {
        result.message = "signUp done";
        result.writeHead(404);
        response.end(JSON.stringify(result));
      } else {
        response.writeHead(200);
        result.message = "signUp done";
        response.end(JSON.stringify(result));
      }
    }
  );
}
module.exports={request};