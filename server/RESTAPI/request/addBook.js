const db = require("../../mysql.js");

function request(id, body, response) {
  console.log(`>> addBook.js >> id :  ${id}`)
  console.log(`>> addBook.js >> data :  ${body}`);
  console.log(body);
  // 예제 코드 일부
  console.log(`>> tableSearch.js >> data :  ${JSON.stringify(body)}, id : ${id}`);

  let targetTable = "book";
  let sql = `INSERT INTO ${targetTable} 
  (book_name, price, publisher, published_year, author, class_id, student_id, upload_time) 
  VALUES(?, ?, ?, ?, ?, ?, ?, ?)`;
  let param = [
    body.name,
    body.price,
    body.publisher,
    body.bookPublishedDate,
    body.author,
    body.classID,
    id,
    body.upload_time,
  ];
  console.log(`>> addBook.js >> param :  `);
  console.log(param);
  db.query(
    sql,
    param,
    function (error, result) {
      if (error) {
        console.log("Error inserting into book:", error);
        response.writeHead(404);
        response.end(JSON.stringify("Insert_bookdata_fail"));
      } else {
        console.log("Inserted into book successfully");
        targetTable = "book";
        sql = `SELECT book_id FROM ${targetTable} WHERE student_id = ?`;
        param = [id];
        console.log(sql);
        db.query(sql, param, function (error, bookResult) {
          if (error) {
            console.log("Error selecting book_id:", error);
            response.end(JSON.stringify("Select_book_id_fail"));
            return ;
          }
          console.log(bookResult[bookResult.length - 1].book_id);
          let bookID = bookResult[bookResult.length - 1].book_id;
          sql = `INSERT INTO status (book_id, ripped, light, pencil, pen, fade, dirty) VALUES(?, ?, ?, ?, ?, ?, ?)`;
          // ['찢김', '하이라이트', '연필자국', '펜자국', '바램', '더러움']
          param = [
            bookID,
            body.bookStateList[0],
            body.bookStateList[1],
            body.bookStateList[2],
            body.bookStateList[3],
            body.bookStateList[4],
            body.bookStateList[5],
          ];
          console.log(sql);
          db.query(
            sql, param,
            function (error, statusResult) {
              if (error) {
                console.log(error);
                console.log(error.code);
                console.log("Error inserting into status:", error);
                response.end(JSON.stringify("Insert_statusdata_fail"));
                return ;
              } else {
                console.log("Inserted into status successfully");
                response.writeHead(200);
                response.end(JSON.stringify({'message':'success'})); // status 테이블에 [상태 정보]가 잘 들어갔는 지.
                return ;
              }
            });
        });
      }
    }
  );
}
 
module.exports = { request };
