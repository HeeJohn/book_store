const db = require("../../../mysql.js");

function request(id, body, response) {
    console.log(`>> updateNotBox.js >> data :  ${body}`);
    //parse
    //----> sql
    let targetTable = "meeting";
    let param = [];
    let set = "";
    if (body == null) {
        response.end(
            JSON.stringify({
                message: ">> updateNotBox.js >> body is null}",
            })
        );
        return;
    }
    if (body.flag == undefined || body.flag == null) {
        set = "MEETING_TIME = ?, PLACE = ?, LATITUDE = ?, LONGITUDE = ?";
        param = [body.time, body.place, body.latitude, body.longitude, body.bookID];
    } else {
        set = "APPROVAL = ?";
        param = [1, body.bookID];
    }

    let sql = `UPDATE ${targetTable} SET ${set}  WHERE BOOK_ID = ?;`;
    console.log(sql);
    console.log(param);
    db.query(sql, param, function (error, result) {
        if (error) {
            response.end(
                JSON.stringify({
                    message: "failed update meeting from meeting table",
                })
            );
            return;
        } else {
            console.log(`>> updateNotBox.js >> updated`);
            response.end(JSON.stringify({ 'message': "success" }));
            return;
        }
    });
}

module.exports = { request };
