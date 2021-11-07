const pipe =
	(...funcs) =>
	(finalValue) =>
		funcs.reduce((value, func) => func(value), finalValue);

const isSpace = (character) => character === ' ';
const isDoubleQuote = (character) => character === '"';
const isCharacter = (character) => character.match(/[A-Za-z0-9]/g);
const transformIfCamelCase = (word) =>
	word.replace(/([a-z])([A-Z])/g, '$1 $2').split(' ');

const removeLines = (chunk) => chunk.replace(/\n/g, ' ');
const removeEmojis = (chunk) => {
	const emojiRegex = /(\p{Emoji_Presentation}|\p{Extended_Pictographic})/gu;
	return chunk.replace(emojiRegex, '');
};

const filterNonCharacter = (chunk) =>
	chunk
		.trim()
		.split('')
		.filter((char) => isCharacter(char) || isSpace(char) || isDoubleQuote(char))
		.join('')
		.split(' ');

const transformDoubleQuote = (chunk) => {
	let startDoubleQuote = false;

	const newChunk = chunk.reduce((newChunk = [], word) => {
		if (word.includes('"')) {
			const wordOnly = word.split('"').join('');

			if (startDoubleQuote) {
				newChunk[newChunk.length - 1] =
					newChunk[newChunk.length - 1] + wordOnly;
				startDoubleQuote = false;
			} else {
				newChunk = [...newChunk, ...transformIfCamelCase(wordOnly)];
				startDoubleQuote = true;
			}
		} else {
			if (startDoubleQuote) {
				newChunk[newChunk.length - 1] = newChunk[newChunk.length - 1] + word;
			} else {
				newChunk = [...newChunk, ...transformIfCamelCase(word)];
			}
		}
		return newChunk;
	}, []);

	return startDoubleQuote ? chunk : newChunk;
};

module.exports = {
	pipe,
	removeLines,
	transformDoubleQuote,
	filterNonCharacter,
	removeEmojis,
	isCharacter
};
