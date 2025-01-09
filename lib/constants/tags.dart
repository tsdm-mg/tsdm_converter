/// Head of tr
const kTrHead = r'\[tr\]';

/// Tail of tr
const kTrTail = r'\[/tr\]';

/// Head of td
const kTdHead = r'\[td=?\d*\]';

/// Tail of td
const kTdTail = r'\[/td\]';

/// Any number
const kNum = r'\d+';

/// Any not @ characters
const kNotAt = '[^@]+';

/// Any not [ characters.
const kNotStart = r'[^\[]+';

/// Any not ] characters.
const kNotClose = r'[^\]]+';

/// Alignment
const kAlignHead = r'\[align=\w*\]';

/// Alignment
const kAlignTail = r'\[/align\]';
