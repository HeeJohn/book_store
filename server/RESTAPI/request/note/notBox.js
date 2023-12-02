const db = require("../../../mysql.js");

function request(id, body, response) {
    console.log(`>> notBox.js >> data :  ${body}`);

    let targetTable = "meeting";
    let joinTable1 = "book";
    let joinTable2 = "user";
    let joinTable3 = "class";
    let comColBook = "book_id";
    let comColStudent = "student_id";
    let comColClassCode = "class_id";

    let sql = `
    SELECT seller.name as seller, buyer.name as buyer, seller.phone as s_phone, buyer.phone as b_phone,
    ${targetTable}.buyer_id, ${targetTable}.seller_id,
    ${joinTable1}.book_name, ${joinTable1}.price, ${joinTable1}.author, ${joinTable1}.book_id,
    ${joinTable1}.publisher, ${joinTable1}.published_year, ${joinTable3}.class_name
    FROM ${targetTable}
    JOIN ${joinTable1} ON meeting.${comColBook} = book.${comColBook}
    JOIN ${joinTable2} AS seller ON meeting.seller_id = seller.${comColStudent}
    JOIN ${joinTable2} AS buyer ON meeting.buyer_id = buyer.${comColStudent}
    JOIN ${joinTable3} ON class.${comColClassCode} = book.${comColClassCode}
    WHERE ( ${targetTable}.buyer_id  = ? OR  ${targetTable}.seller_id  = ?)
    AND ${targetTable}.approval = ?`;


    if(body.booKID!=undefined || body.booKID != null){
        sql = sql + `${targetTable}.book_id = ${body.booKID};`
    }else{
        sql = sql +';';
    }
    let param = [id, id,body.flag];
    console.log(sql);
    console.log(param);

    db.query(sql, param, function (error, result) {
        if (error) {
            console.log(`>> notBox.js >> error : ${error}`);
            response.end(
                JSON.stringify({
                    message: `failed to read * from ${targetTable}`
                }));
            return;
        } else {
            console.log(`>> notBox.js >> ${result}`);
            response.end(JSON.stringify({ "message": "success", 'data': result, 'id':id}));
            return;
        }
    });
}

module.exports = { request };
