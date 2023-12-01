const db = require("../../mysql.js");

function request(id, body, response) {
  console.log(`>> delNotBox.js >> data :  ${body}`);
  //----> sql
  let targetTable = "meeting";
  
  let sql = `DELETE FROM ${targetTable} WHERE book_id = ?;`;
  let param = [body.bookID];

  db.query(sql, param, function (error, classCodes) {
    if (error) {
      console.log(error);
      console.log(error.code);
      response.end(JSON.stringify({ message: "failed to delete book_id from meeting" }));
      return ;
    } else {
      response.writeHead(200);
      response.end(JSON.stringify({ message: "success" }));
      return ;
    }
  });
}

module.exports = { request };
