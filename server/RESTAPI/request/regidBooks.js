const db = require("../../mysql.js");

function request(id, body, response) {
  console.log(`>> regidBooks.js >> data :  ${body}`);

  //----> sql
  let targetTable = "book";
  let joinTable1 = "status";
  let joinTable2 = "register_book";
  let commonColumn = "book_id";
  if(body.how =='book_id'){
    body.how = `${joinTable1}.light+${joinTable1}.pencil+${joinTable1}.pen+${joinTable1}.dirty+${joinTable1}.fade+${joinTable1}.book_id+status.ripped`;
  }
  let sql = `
    SELECT * 
    FROM ${targetTable}
    JOIN ${joinTable1} ON ${targetTable}.${commonColumn} = ${joinTable1}.${commonColumn}
    JOIN ${joinTable2} ON ${targetTable}.${commonColumn} = ${joinTable2}.${commonColumn}
    WHERE ${joinTable2}.STUDENT_ID = ?
    ORDER BY ? DESC;
  `;

  let param = [id,body.how];

  db.query(
    sql, param,
    function (error, result) {
      if (error) {
        console.log("Error ---> book:", error);
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
