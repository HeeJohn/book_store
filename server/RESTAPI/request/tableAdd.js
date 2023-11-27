const db = require('../../mysql.js');

function request(id, body, response) {
  console.log(`>> tableAdd.js >> data :  ${body}`);
  //parse
  //----> sql
  let targetTable= 'class_table';
  let guide = `student_id`;
  let values =`${id}`;
  let param = body.class_code;
  console.log(param);
  for(let i =0;i<param.length;i++){
    guide += `,class${i+1}_id`;
    values += ',?';
  }
  let sql = `INSERT INTO ${targetTable}(${guide}) VALUES(${values})`;
  console.log(sql);
  console.log(param);
  db.query(sql, param, function (error, result) {
      if (error) {
        console.log(error);
        response.end(JSON.stringify({'message' : 'inserting classTable info into class table failed.'}));
      } else {
        console.log(sql);
        console.log(param);
        response.writeHead(200);
        result.message = "success";
        response.end(JSON.stringify(result));
      }
    }
  );
}
module.exports={request};