const through2 = require('through2');
const {
	pipe,
	removeLines,
	removeEmojis,
	filterNonCharacter,
	transformDoubleQuote,
	isCharacter
} = require('./utils');

module.exports = function () {
	let words = 0;
	let lines = 0;
	let bytes = 0;
	let characters = 0;
	let tokens = [];

	function transform(chunk, encoding, cb) {
		if (!chunk) return cb();

		bytes = Buffer.byteLength(chunk, encoding);

		lines = chunk.split('\n').filter((line) => line).length;

		tokens = pipe(
			removeLines,
			removeEmojis,
			filterNonCharacter,
			transformDoubleQuote
		)(chunk);

		words = tokens.length;
		characters = tokens.join('').split('').filter(isCharacter).join('').length;

		return cb();
	}

	function flush(cb) {
		this.push({
			words,
			lines,
			bytes,
			characters
		});
		this.push(null);
		return cb();
	}

	return through2.obj(transform, flush);
};
