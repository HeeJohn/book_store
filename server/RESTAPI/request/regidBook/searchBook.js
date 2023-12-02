const db = require("../../../mysql.js");

function request(id, body, response) {
  console.log(`>> searchBooks.js >> data :  ${body}`);
  console.log(`body-->${body.how}`);
  //----> sql
  let targetTable = "book";
  let joinTable = "status";
  let commonColumn = "book_id";
  if(body.how =='book_id'){
    body.how = `${joinTable}.light+${joinTable}.pencil+${joinTable}.pen+${joinTable}.dirty+${joinTable}.fade+${joinTable}.book_id+status.ripped`;
  }
  let sql = `
    SELECT * 
    FROM ${targetTable}
    JOIN ${joinTable} ON ${targetTable}.${commonColumn} = ${joinTable}.${commonColumn}
    WHERE ${targetTable}.STUDENT_ID = ? AND  ${targetTable}.CLASS_ID = ?
    ORDER BY (${body.how})  ${body.order};
  `;

  let param = [id, body.classID];
  console.log(sql);
  console.log(param);
  db.query(
    sql, param,
    function (error, result) {
      if (error) {
        console.log("searchBooks ---> book:", error);
        response.end(JSON.stringify(null));
        return ;
      } else {
        response.writeHead(200);
        console.log(result.length);
        console.log(result);
        response.end(JSON.stringify({'message':'success', 'data':result})); 
        return ;
      }
    }
  );
}

module.exports = { request }; 
