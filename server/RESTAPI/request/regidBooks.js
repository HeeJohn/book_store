const db = require("../../mysql.js");

function request(body, response) {
  console.log(`>> regidBooks.js >> data :  ${body}`);

  let base64Image = body.img; // image_picker에서 받아온 base64 데이터
  let base64Data = base64Image.replace(/^data:image\/\w+;base64,/, ""); // url이 포함되어있으므로 url 제거.
  let imageBuffer = Buffer.from(base64Data, "base64"); // 이진 데이터로 변환. 이 상태로 db에 들어감.
  //----> sql
  targetTable = "book";
  sql = `INSERT INTO ${targetTable} (book_name, price, publisher, year, author, class_code, student_id) VALUES(?, ?, ?, ?, ?, ?, ?)`; //책정보를 book 테이블에 저장.
  db.query(
    sql,
    [
      body.book_name,
      body.price,
      body.publisher,
      body.year,
      body.author,
      body.class_code,
      body.student_id,
    ],
    function (error, result) {
      if (error) {
        console.log("Error inserting into book:", error);
        response.writeHead(404);
        response.end(JSON.stringify("Insert_bookdata_fail"));
      } else {
        console.log("Inserted into book successfully");

        sql = `SELECT book_id FROM book WHERE student_id = ?`; // 해당 학번의 book_id를 가져옴.
        db.query(sql, [body.student_id], function (error, bookResult) {
          if (error) {
            console.log("Error selecting book_id:", error);
            response.writeHead(404);
            response.end(JSON.stringify("Select_book_id_fail"));
          } else {
            let book_id = bookResult[-1].book_id; // book_id를 꺼내서 변수에 담음. status 테이블에 넣기 위해서.
            sql = `INSERT INTO status (book_id, light, pencil, pen, dirty, rip, fade, wrinkle) VALUES(?, ?, ?, ?, ?, ?, ?, ?)`;
            db.query(
              sql,
              [
                book_id,
                body.light,
                body.pencil,
                body.pen,
                body.dirty,
                body.rip,
                body.fade,
                body.wrinkle,
              ],
              function (error, statusResult) {
                if (error) {
                  console.log("Error inserting into status:", error);
                  response.writeHead(404);
                  response.end(JSON.stringify("Insert_statusdata_fail"));
                } else {
                  console.log("Inserted into status successfully");
                  response.writeHead(200);
                  response.end(JSON.stringify(statusResult)); // status 테이블에 [상태 정보]가 잘 들어갔는 지.
                }
              }
            );
          }
        });
      }
    }
  );
}
module.exports = { request };
