var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
}).listen(8080, '10.0.2.71');
console.log('Server running at http://10.0.2.71:8080/');
