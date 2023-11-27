const http = require("http");
const url = require("url");
const ctr = require("./RESTAPI/controller.js");

const app = http.createServer(function (request, response) {
  const targetUrl = request.url;
  const method = request.method;
  console.log(">> server.js >> METHOD:", method);
  console.log(">> server.js >> RUNTIMETYPE METHOD:", typeof method);
  let requestData = "";
  const headers = request.headers["authorization"];
  console.log(">> server.js >> Headers:", headers);
  const sessionID = headers.substring("Basic".length).trim();
  console.log(`>> server.js >> ${sessionID}`);

  if (method == "GET") {
    console.log(">> server.js >> isSide get");
    ctr.controller(targetUrl, null, sessionID, response);
  } else {
    request.on("data", function (stream) {
      requestData += stream;
    });

    request.on("end", function () {
      let parsedData = JSON.parse(requestData);
      console.log(`>> server.js >> ${parsedData}`);
      ctr.controller(targetUrl, parsedData, sessionID, response);
    });
  }
});
app.listen(3000);
