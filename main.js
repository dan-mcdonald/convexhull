var convexHull = require('./lib/lib');
var fs = require('fs');

var input;
var fileName = process.argv[2];

if(fileName === undefined) {
  console.error("Reading input from stdin");
  input = process.stdin;
} else {
  input = fs.createReadStream(fileName);
}

var p = convexHull.parsePointStream(input).then(convexHull.monotoneChain).then(function(points) {
  convexHull.exportPointStream(process.stdout, points);
}, function(err) {
  console.error(err);
  process.exit(1);
});
