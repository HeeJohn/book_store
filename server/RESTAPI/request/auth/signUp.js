const db = require('../../../mysql.js');


function request(body, response) {
  console.log(`>> signUp.js >> data :  ${body}`);
  //----> sql
  let targetTable= 'user';
  let sql = `INSERT INTO ${targetTable} (phone, name, student_id, password) VALUES (?, ?, ?, ?);`;
  let param = [body.phone, body.name, body.id, body.password];
  db.query(sql, param, function (error, result) {
    if(error){
      if (error.code= 'ER_DUP_ENTRY') {
        console.log(`>> signUp.js >> signUp id duplicated`);
        console.log(error);
        response.end(JSON.stringify({"message": "duplicated"}));
        return ;
      }
    } else {
        response.writeHead(200);
        result.message = "signUp done";
        response.end(JSON.stringify(result));
        return ;
      }
    }
  );
}
module.exports={request};