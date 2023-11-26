const db = require('../../mysql.js');


function request(body, response) {

  //----> sql
  let targetTable= 'class';
  let sql = `SELECT * FROM ${targetTable} WHERE class_name LIKE ? OR class_name LIKE ?
  ORDER BY class_name LIMIT 5;`;
  let param = [`${body.text}%`,`%${body.text}%` ];
  
  db.query(sql, param, function (error, result) {
      if (error) {
        response.writeHead(200);
        response.end(JSON.stringify({'message':'success', 'data' : null}));
      }
      else {
          if (result === null || result.length === 0) {
              console.log('결과 값이 없습니다.');
          }
          console.log(`클래스 데이터 보내는 중 ${result}`);
          response.writeHead(200);
          response.end(JSON.stringify({'message':'success', 'data' : result}));
      }
  });
  
}
module.exports={request};