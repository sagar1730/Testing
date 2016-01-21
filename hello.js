var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
}).listen(8080, '54.208.23.139');
console.log('Server running at http://54.208.23.139:8080/');
