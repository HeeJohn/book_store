const db = require("../../mysql.js");

function request(id, body, response) {
  console.log(`>> removeBook.js >> data :  ${body}`);
  //----> sql
  let targetTable = "book";
  let condition = 'book_id';
  let sql = `DELETE FROM ${targetTable} WHERE ${condition} = ?;`;
  let param = [body.bookID];

  db.query(sql, param, function (error, result) {
    if (error) {
      console.log(error);
      console.log(error.code);
      response.end(JSON.stringify({ message: "failed to delete book from book" }));
      return ;
    } else {
      response.writeHead(200);
      response.end(JSON.stringify({ message: "success" }));
      return ;
    }
  });
}

module.exports = { request };
