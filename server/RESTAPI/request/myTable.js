const db = require('../../mysql.js');


function request(id, body, response) {
  console.log(`>> myTable.js >> data :  ${body}`);
  //----> sql
  let targetTable= 'class_table';
  let sql = `SELECT * FROM ${targetTable} WHERE STUDENT_ID = ?;`;
  let param = [id];
  db.query(sql, param, function (error, classCodes) {
    if (error) {
      response.end(JSON.stringify({'message': 'failed to bring class_codes'}));
    } else {
      console.log(classCodes[0]);
       let class_codes = classCodes[0].
       
       targetTable= 'class';
       sql = `SELECT * FROM ${targetTable} WHERE STUDENT_ID = ?;`;
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
  }
);


}
module.exports={request};