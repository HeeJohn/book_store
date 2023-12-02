const db = require("../../../mysql.js");

function request(id, body, response) {
  console.log(`>> delMyTable.js >> data :  ${body}`);
  //----> sql
  let targetTable = "class_table";
  
  let sql = `DELETE FROM ${targetTable} WHERE STUDENT_ID = ? AND CLASS_ID = ?;`;
  let param = [id, body.classID];

  db.query(sql, param, function (error, classCodes) {
    if (error) {
      console.log(error);
      console.log(error.code);
      response.end(JSON.stringify({ message: "failed to delete class from class_table" }));
      return ;
    } else {
      response.writeHead(200);
      response.end(JSON.stringify({ message: "success" }));
      return ;
    }
  });
}

module.exports = { request };
