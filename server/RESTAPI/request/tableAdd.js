const db = require("../../mysql.js");

function request(id, body, response) {
  console.log(`>> tableAdd.js >> data :  ${body}`);
  //parse
  //----> sql
  let targetTable = "class_table";
  const student_id = "student_id";
  let guide = ``+student_id;
  let values = `${id}`;
  let param = body.class_code;
  console.log(param);
  for (let i = 0; i < param.length; i++) {
    guide += `,class${i + 1}_id`;
    values += ",?";
  }
  let sql = `INSERT INTO ${targetTable}(${guide}) VALUES(${values})`;
  console.log(sql);
  console.log(param);
  db.query(sql, param, function (error, result) {
    if (error.code == "ER_DUP_ENTRY") {
    guide = guide.substring(student_id.length+1)
    guide =  guide.replaceAll('id' ,'id=?');
    console.log(guide);
      sql = `UPDATE ${targetTable} SET ${guide} WHERE STUDENT_ID = ${id};`;
      console.log(sql);
      db.query(sql, param, function (udpateError, result) {
        if(udpateError){
          response.end(
            JSON.stringify({
              message: "updating classTable info into class table failed."
            }));
        }
      
        console.log(`>> tableAdd.js >> updated`);
        result.message = "success";
     
        response.end(JSON.stringify({"message" : "success"}));
      });
    } else {
      console.log(`>> tableAdd.js >> updated`);
      result.message = "success";
      response.end(JSON.stringify({"message" : "sucess"}));
    }
  });
}
module.exports = { request };
