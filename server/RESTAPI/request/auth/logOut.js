const db = require("../../../mysql.js");

function request(id, body, response) {
  console.log(`>> logOut.js >> data :  ${body}`);
  //----> sql
  let targetTable = "SESSION";
  let sql = `DELETE FROM ${targetTable} WHERE STUDENT_ID = ?;`;
  let param = [id];
  console.log(sql);
  console.log(param);
  db.query(sql, param, function (error, result) {
    if (error) {
      console.log(error);
      console.log(`>> logOut.js >> logOut failed id`);
      response.end(JSON.stringify({ message: "failed to logOut" }));
      return ;
    } else {
      /* ------ logOut success remove sessionId ------*/
      response.writeHead(200);
      response.end(
        JSON.stringify({
          message: "success",
        })
      );
      return ;
    }
  });
}

module.exports = { request };
