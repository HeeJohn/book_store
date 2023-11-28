const db = require("../../mysql.js");

function request(id, body, response) {
  console.log(`>> regidBooks.js >> data :  ${body}`);

  //----> sql
  let targetTable = "book";
  let joinTable = "status";
  let commonColumn = "book_id";

  let sql = `
    SELECT *
    FROM ${targetTable}
    JOIN ${joinTable} ON ${targetTable}.${commonColumn} = ${joinTable}.${commonColumn}
    WHERE ${targetTable}.STUDENT_ID = ?
  `;

  let param = [id];

  db.query(
    sql, param,
    function (error, result) {
      if (error) {
        console.log("Error ---> book:", error);
        response.end(JSON.stringify(null));
      } else {
        response.writeHead(200);
        console.log(result[0]);
        response.end(JSON.stringify({'message':'success', 'data':result})); 
      }
    }
  );
}

module.exports = { request }; 
