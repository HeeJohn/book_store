const db = require('../../mysql.js');

function request(id, body, response) {
  console.log(`>> myTable.js >> data :  ${body}`);
  //----> sql
  let targetTable = 'class_table';
  let sql = `SELECT * FROM ${targetTable} WHERE STUDENT_ID = ?;`;
  let param = [id];
  db.query(sql, param, function (error, classCodes) {
    if (error) {
      throw error;
      response.end(JSON.stringify({ 'message': 'failed to bring class_codes' }));
    } else {
      let classIds = [];
      for (let i = 1; i <= 10; i++) {
        let classId = classCodes[0][`class${i}_id`];
        if (classId !== null) {
          classIds.push(classId);
        }
      }

      console.log(`>> myTable.js >> classIds :  ${classIds}` );
      targetTable = 'class';
      sql = `SELECT * FROM ${targetTable} WHERE class_id IN (?);`;
      db.query(sql, [classIds], function (error, result) {
        if (error) {
          result.message = "getting class info from mytable failed.";
          result.writeHead(404);
          response.end(JSON.stringify(result));
        } else {
          response.writeHead(200);
          result.message = "success";
          response.end(JSON.stringify({'message': 'success', 'data' : result}));
        }
      });
    }
  });
}

module.exports = { request };
