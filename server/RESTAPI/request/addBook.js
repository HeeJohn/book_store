const db = require("../../mysql.js");

function request(body, response) {
    console.log(`>> addBook.js >> data :  ${body}`);

    let base64Image = body.img; // image_picker에서 받아온 base64 데이터
    let base64Data = base64Image.replace(/^data:image\/\w+;base64,/, ""); // url이 포함되어있으므로 url 제거.
    let imageBuffer = Buffer.from(base64Data, "base64"); // 이진 데이터로 변환. 이 상태로 db에 들어감.
    //----> sql
    let targetTable = "book";
    let sql = `INSERT INTO ${targetTable} (image, book_name, price, publisher, year, author, class_code, student_id) VALUES(?, ?, ?, ?, ?, ?, ?, ?)`;
    let param = [
        imageBuffer,
        body.book_name,
        body.price,
        body.publisher,
        body.year,
        body.author,
        body.class_code,
        body.student_id,
    ];

    db.query(sql, param, function (error, result) {
        if (error) {
            response.writeHead(404);
            response.end(JSON.stringify("Insert_bookdata_fail"));
            throw error;
        } else {
            sql = `SELECT book_id FROM book WHERE student_id = ?`; // book 테이블에 book_id 가져오는 쿼리문.
            param = [body.student_id];
            db.query(sql, param, function (error, result) {
                if (error) {
                    response.writeHead(404);
                    response.end(JSON.stringify("Select_book_id_fail"));
                    throw error;
                } else {
                    let book_id = result.book; // 방금 들어간 book_id를 꺼내서 변수에 담음. status 테이블에 넣기 위해서.
                    sql = `INSERT INTO status (book_id, light, pencil, pen, dirty, rip, fade, wrinkle) VALUES(?, ?, ?, ?, ?, ?, ?, ?)`;
                    param = [
                        book_id,
                        body.light,
                        body.pencil,
                        body.pen,
                        body.dirty,
                        body.rip,
                        body.fade,
                        body.wrinkle,
                    ];
                    db.query(sql, param, function (error, result) {
                        if (error) {
                            response.writeHead(404);
                            response.end(JSON.stringify("Insert_statusdata_fail"));
                            throw error;
                        } else {
                            response.writeHead(200);
                            response.end(JSON.stringify(result)); // status 테이블에 [상태 정보]가 잘 들어갔는 지.
                        }
                    });
                    response.writeHead(200);
                    response.end(JSON.stringify(result)); // book 테이블에서 book_id를 잘 가져왔는 지.
                }
            });
            response.writeHead(200);
            response.end(JSON.stringify(result)); // book 테이블에 [책 정보]가 잘 들어갔는 지.
        }
    });
}
module.exports = { request };
