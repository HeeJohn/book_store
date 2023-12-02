const db = require("../../../mysql.js");

function request(id, body, response) {
    console.log(`>> readMeeting.js >> data :  ${body}`);
    //parse
    //----> sql
    let targetTable = "meeting";
    let param = [body.bookID];
    let selected = 'meeting_time as time, place, latitude, longitude';
    let sql = `SELECT ${selected} FROM ${targetTable} WHERE BOOK_ID = ?;`;
    console.log(sql);
    console.log(param);
    db.query(sql, param, function (error, result) {
        if (error) {
            response.end(
                JSON.stringify({
                    message: "failed update meeting from meeting table",
                })
            );
        } else {
            console.log(`>> updateNotBox.js >> updated`);
            response.end(JSON.stringify({ 'message': "success", 'data' : result }));
            return;
        }
    });
    console.log(`>> updateNotBox.js >> unexpected error`);
    return;
}

module.exports = { request };
