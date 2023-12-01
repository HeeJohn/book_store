const db = require('../../mysql.js');

function request(id, body, response) {
  console.log(`>> myTable.js >> data :  ${body}`);
  //----> sql
  let targetTable = 'class';
  let subTable = 'class_table';
  let condition = 'class_id';
  let sql = `SELECT * FROM ${targetTable} 
             WHERE ${condition} in (SELECT ${condition} 
                                  FROM ${subTable} 
                                  WHERE STUDENT_ID = ?);`;
  let param = [id];
  console.log(sql);
  db.query(sql, param, function (error, classIDs) {
    if (error) {
      console.log(error);
      console.log(error.code);
      response.end(JSON.stringify({ 'message': 'failed to bring class_codes' }));
      return;
    } else {
      if (classIDs.length === 0 || classIDs[0] === undefined) {
        response.end(JSON.stringify({ 'message': 'no data' }));
        return;
      }
      response.end(JSON.stringify({ 'message': 'success', 'data': classIDs }));
      return;
    }
  });
}

module.exports = { request };
