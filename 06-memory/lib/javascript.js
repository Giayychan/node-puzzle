const fs = require('fs');
const readline = require('readline');
const stream = require('stream');

exports.countryIpCounter = (countryCode, cb) => {
	if (!countryCode) return cb();

	const readStream = fs.createReadStream(__dirname + '/../data/geo.txt');
	const outStream = new stream();
	const rl = readline.createInterface(readStream, outStream);

	let counter = 0;

	rl.on('line', function (chunk) {
		let [data] = chunk.split('\n');
		if (data && data.includes(countryCode)) {
			const [geoFieldMin, geoFieldMax, _, ipCountryCode] = data[0].split('\t');
			if (ipCountryCode && ipCountryCode === countryCode) {
				counter += +geoFieldMax - +geoFieldMin;
			}
		}
	}).on('close', function () {
		cb(null, counter);
	});
};
