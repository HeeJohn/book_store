const mysql = require('mysql'); //mysql 모듈 불러오기.

// 비밀번호는 별도의 파일로 분리해서 버전관리에 포함시키지 않아야 합니다.
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'heejohn1423!',
    database: 'bookstore',
});

db.connect(); // 실제로 연결.
module.exports = db;


// db.end(); // 연결 종료.


