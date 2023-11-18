const qs = require("querystring");
const db = require('../mysql.js');
const addr = require('./cosnt/address.js');
const attributes = require('./cosnt/attributes.js');
function controller(request){


    let field= '';
    let targetTable = '';
  
  
  
  
  
    switch(request){
        case addr.gpsURL:
            db.query(`SELECT * FROM ${targetTable}`, function (error, result) {
                if (error) {
                    throw error;
                  }
                  let a = 5;
               
              });
            break;
        case addr.signUpURL :
        targetTable = 'gps';
            db.query(`SELECT * FROM ${targetTable}`, function (error, result) {
                if (error) {
                    throw error;
                  }
                  let a = 5;
                response.writeHead(200);
                response.end(JSON.stringify({ message: 'success' }));
              });
            break;
        case addr.logInURL :
            db.query(`SELECT * FROM ${targetTable}`, function (error, result) {
                if (error) {
                    throw error;
                  }
                  let a = 5;
                response.writeHead(200);
                response.end(JSON.stringify({ message: 'success' }));
              });
            break;
        case addr.splashURL:
          targetTable = 'student';
            db.query(`SELECT student_id FROM ${targetTable}
            where student_id`, function (error, result) {
                if (error) {
                    throw error;
                  }
                  
              });
            break;
        case addr.gpsURL:
            db.query(`SELECT * FROM ${targetTable}`, function (error, result) {
                if (error) {
                    throw error;
                  }
                  let a = 5;
                response.writeHead(200);
                response.end(JSON.stringify({ message: 'success' }));
              });
             break;
        default: 
    }

    return response;
}


module.exports = { controller };