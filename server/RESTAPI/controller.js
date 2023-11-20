const qs = require("querystring");
const db = require('../mysql.js');
const addr = require('./cosnt/address.js');
const attributes = require('./cosnt/attributes.js');

function controller(targetUrl, body, sessionID, response) {
    let targetTable = '';
    switch (targetUrl) {
        case addr.gpsURL:
            db.query(`SELECT * FROM ${targetTable}`, function (error, result) {
                if (error) {
                    throw error;
                }
                response.writeHead(200);
                response.end(JSON.stringify(result));
            });
            break;
        case addr.signUpURL:
            targetTable = 'user';
            // TODO: 적절한 데이터 삽입 방법을 사용하여 쿼리를 작성
            db.query(`INSERT INTO ${targetTable} (phone, name, student_id, password) 
                      VALUES (?, ?, ?, ?)`, [body.phone, body.name, body.id, body.password], function (error, result) {
                if (error) {
                    throw error;
                }else{
                response.writeHead(200);
                result.message ="signUp done";
                response.end(JSON.stringify(result));
                }
          
            });
            break;
        case addr.logInURL:
            // TODO: 로그인 로직 구현
            break;
        case addr.splashURL:
            targetTable = 'student';
            db.query(`SELECT student_id FROM ${targetTable} WHERE student_id = ?`, [body.student_id], function (error, result) {
                if (error) {
                    throw error;
                }
                response.writeHead(200);
                response.end(JSON.stringify(result));
            });
            break;
        default:
            // 처리할 URL이 없는 경우
            response.writeHead(404);
            response.end(JSON.stringify({ message: 'Not Found' }));
    }
}
module.exports = { controller };
