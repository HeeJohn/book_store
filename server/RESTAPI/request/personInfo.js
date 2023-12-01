const db = require("../../mysql.js");

function request(id, body, response) {
    console.log(`>> personInfo.js >> data :  ${body}`);

    //----> sql
    let targetTable = "user";
    let sql = `
    SELECT name
    FROM ${targetTable}
    WHERE STUDENT_ID = ?
  `;
    let param = [id];
    db.query(
        sql, param,
        function (error, result) {
            if (error) {
                console.log("Error ---> book:", error);
                response.end(JSON.stringify(null));
                return ;
            } else {
                response.writeHead(200);
                console.log(result[0].name);
                let name = result[0].name;
                response.end(JSON.stringify({ 'message': 'success', 'data': { name, 'student_id': id } }));
                return ;
            }
        }
    );
}

module.exports = { request }; 
