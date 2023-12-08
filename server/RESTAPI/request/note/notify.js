const db = require("../../../mysql.js");

function request(id, body, response) {
    console.log(`>> notify.js >> data :  ${body}`);
    //parse
    //----> sql
    let targetTable = "meeting";
    let param = [];

    let sql = `INSERT INTO ${targetTable}(buyer_id, seller_id, book_id) VALUES(?, ?, ?);`;
    console.log(body.bookID);
    
    param = [id, body.sellerID, body.bookID];
    console.log(sql);
    console.log(param);
    db.query(sql, param, function (error, result) {
        if (error) {
            console.log(`>> notify.js >> error : ${error}`);
            switch (error.code) {
                case "ER_DUP_ENTRY":
                    response.end(
                        JSON.stringify({
                            message: "already exist in the meeing table"
                        }));
                    return;
            }
            response.end(
                JSON.stringify({
                    message: "failed inserting meeting into meeting table"
                }));
        } else {
            console.log(`>> notify.js >> inserted`);
            response.end(JSON.stringify({ "message": "success" }));
            return;
        }
    });
    console.log(`>> tableAdd.js >> unexpected error`);
    return;
}

module.exports = { request };