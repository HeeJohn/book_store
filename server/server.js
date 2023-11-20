const http = require("http");
const url = require("url");
const ctr = require("./RESTAPI/controller.js");

const app = http.createServer(function (request, response) {
  const targetUrl = request.url;
  let requestData = "";
  const headers = request.headers['authorization'];
  console.log("Headers:", headers);
  const sessionID = headers.substring('Basic'.length);
  request.on("data", function (stream) {
    requestData += stream;
  });

  request.on("end", function () {
    let parsedData = JSON.parse(requestData);
    console.log(parsedData);
    ctr.controller(targetUrl, parsedData, sessionID, response);
  });
});
app.listen(3000);
