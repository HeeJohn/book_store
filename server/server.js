const http = require("http");
const url = require("url");
const ctr = require("./RESTAPI/controller.js");

const app = http.createServer(function (request, response) {
  const data = ctr.controller(request);
  let _url = request.url; 
  let queryData = url.parse(_url, true).query;
  let  pathname = url.parse(_url, true).pathname;
  let body = request.map
  response.writeHead(200);
  response.end(JSON.stringify({data}));
}); 

app.listen(3000);
