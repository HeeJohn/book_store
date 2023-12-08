const db = require("../../../mysql.js");

function request(id, body, response) {
  console.log(`>> tableAdd.js >> data :  ${body}`);
  //parse
  //----> sql
  let targetTable = "class_table";
  let param = [];
  let sql = `INSERT INTO ${targetTable}(student_id, class_id) VALUES(${id}, ?);`;
  let classIDs = body.class_id;
  console.log(classIDs);
  console.log(classIDs.length);
  for(let  i =0 ;i< classIDs.length ; i++){
  param = classIDs[i];
  console.log(sql);
  console.log(param);
  db.query(sql, param, function (error, result) {
    if (error) {
      console.log(`>> tableAdd.js >> error : ${error}`);
      switch (error.code) {
        case "ER_DUP_ENTRY":
          sql = `UPDATE ${targetTable} SET class_id = ? WHERE STUDENT_ID = ${id};`;
          console.log(sql);
          db.query(sql, param, function (udpateError, result) {
            if (udpateError) {
              console.log(`>> tableAdd.js >> updated`);
              response.end(
                JSON.stringify({
                  message: "updating classTable info into class table failed."
                }));
              return;
            } else {
              console.log(`>> tableAdd.js >> updated`);
              response.end(JSON.stringify({ "message": "success" }));
              return;
            }
          });
          console.log(`>> tableAdd.js >> unexpected error`);
          return ;
      }
    } else {
      console.log(`>> tableAdd.js >> updated`);
      result.message = "success";
      response.end(JSON.stringify({ "message": "success" }));
      return;
    }
  });
}
}
module.exports = { request };
