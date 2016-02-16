/* * 
 * ShapeChange Antlr - SBVR Grammar
 *
 * This file is part of ShapeChange Antlr, a project that creates antlr 
 * parsers for ShapeChange. 
 * 
 * ShapeChange takes a ISO 19109 Application Schema from a UML model and 
 * translates it into a GML Application Schema or other implementation 
 * representations.
 *
 * Additional information about the software can be found at
 * http://shapechange.net/
 *
 * (c) 2002-2015 interactive instruments GmbH, Bonn, Germany
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Contact:
 * interactive instruments GmbH
 * Trierer Strasse 70-72
 * 53115 Bonn
 * Germany
 */
grammar SBVR;

@header {
	import de.interactive_instruments.antlr.ShapeChangeAntlr.*;
}

@parser::members {

	public SbvrParserHelper helper = new SbvrParserHelper();
	
	public boolean isNoun() { 
		
		String token = getCurrentToken().getText();
		return helper.isNoun(token);		
	}
	
	public boolean isVerb() {
		
		String token = getCurrentToken().getText();
		return helper.isVerb(token);
	}
}

// PARSER RULES

sentence
:
	(
		sentenceUsingObligation
		| sentenceUsingShall
	) '.'? EOF
;

sentenceUsingObligation
:
	(
		obligation = 'It is obligatory that'
		| prohibition = 'It is prohibited that'
	) quantification conditionInSentenceUsingObligation
;

conditionInSentenceUsingObligation
:
	verbExpr
	(
		andornot verbExpr
	)*
;

sentenceUsingShall
:
	quantification conditionInSentenceUsingShall
;

conditionInSentenceUsingShall
:
	modality verbExpr
	(
		andor modality verbExpr
	)*
;

quantification
:
	quantifier
	{isNoun()}? < fail = {"- the concept is not a noun concept."} >

	noun = CONCEPT
	(
		relativeClauseExpr
	)?
;

relativeClauseExpr
:
	relativeClause
	(
		andor relativeClause
	)*
;

relativeClause
:
	'with' singlePredicate
	| 'that'
	(
		not = 'not'
		| not = 'does not'
	)? verbExpr
;

quantificationWithOptionalQuantifierInVerbExpression
:
	quantifier?
	{isNoun()}? < fail = {"- the concept is not a noun concept."} >

	noun = CONCEPT
	(
		relativeClauseExpr
		| predicate
	)?
;

andor
:
	and = 'and'
	| or = 'or'
;

andornot
:
	and = 'and'
	| andNot = 'and not'
	| or = 'or'
	| orNot = 'or not'
;

modality
:
	shall = 'shall'
	| shallNot = 'shall not'
	| should = 'should'
	| shouldNot = 'should not'
;

/* 
 * Because quantifiers can be placed at the start of a sentence, 
 * they must recognize both upper and lower case for the first
 * character.
 */
quantifier
:
	'An' # UniversalQuantifier
	| 'an' # UniversalQuantifier
	| 'All' # UniversalQuantifier
	| 'all' # UniversalQuantifier
	| 'A' # UniversalQuantifier
	| 'a' # UniversalQuantifier
	| 'Each' # UniversalQuantifier
	| 'each' # UniversalQuantifier
	| 'At least one' # ExistentialQuantifier
	| 'at least one' # ExistentialQuantifier
	| 'Exactly one' # ExactlyOneQuantifier
	| 'exactly one' # ExactlyOneQuantifier
	| 'At most one' # AtMostOneQuantifier
	| 'at most one' # AtMostOneQuantifier
	| 'At most' value = UNSIGNED_INT # AtMostNQuantifier
	| 'at most' value = UNSIGNED_INT # AtMostNQuantifier
	| 'At least' value = UNSIGNED_INT # AtLeastNQuantifier
	| 'at least' value = UNSIGNED_INT # AtLeastNQuantifier
	| 'More than one' # AtLeast2Quantifier
	| 'more than one' # AtLeast2Quantifier
	| 'Exactly' value = UNSIGNED_INT # ExactlyNQuantifier
	| 'exactly' value = UNSIGNED_INT # ExactlyNQuantifier
	| 'At least' lowerValue = UNSIGNED_INT 'and at most' upperValue =
	UNSIGNED_INT # NumericRangeQuantifier
	| 'at least' lowerValue = UNSIGNED_INT 'and at most' upperValue =
	UNSIGNED_INT # NumericRangeQuantifier
;

singlePredicate
:
	quantifier?
	(
		prefixedPredicate
		| assignmentPredicate
	)
;

prefixedPredicate
:
	{isNoun()}? < fail = {"- the concept is not a noun concept."} >

	noun = CONCEPT predicate
;

predicate
:
	(
		not = 'not'
	)?
	(
		comparisonPredicate
		| ofTypePredicate
	)
;

comparisonPredicate
:
	comparisonKeyword
	(
		nameExpr
		| number
	)
;

ofTypePredicate
:
	(
		'of-type'
		| 'of type'
	) nameExpr
	(
		'or' nameExpr
	)*
;

assignmentPredicate
:
	'assigned'
	{isNoun()}? < fail = {"- the concept is not a noun concept."} >

	noun = CONCEPT 'value'?
;

comparisonKeyword
:
	'equal-to' # equalTo
	| 'equal to' # equalTo
	| 'other-than' # otherThan
	| 'other than' # otherThan
	| 'higher-than' # higherThan
	| 'higher than' # higherThan
	| 'higher-or-equal-to' # higherOrEqualTo
	| 'higher or equal to' # higherOrEqualTo
	| 'lower-than' # lowerThan
	| 'lower than' # lowerThan
	| 'lower-or-equal-to' # lowerOrEqualTo
	| 'lower or equal to' # lowerOrEqualTo
;

/* match a name expression */
nameExpr
:
	values += NAME
	| '(' values += NAME
	(
		',' values += NAME
	)* ')'
;

/* match a verb  expression*/
verbExpr
:
	{isVerb()}? < fail = {"- the concept is not a verb concept."} >

	verb = CONCEPT
	(
		quantificationWithOptionalQuantifierInVerbExpression
		| assignmentPredicateInVerbExpression
	)
;

assignmentPredicateInVerbExpression
:
// only useful if verb is 'has' or 'have'

	(
		quantifier? assignmentPredicate
	)
	| assignmentAndOtherThan
;

assignmentAndOtherThan
:
	'assigned value other than' nameExpr
;

number
:
	unary_operator? unsigned_number
;

unary_operator
:
	'+' # plus
	| '-' # minus
;

unsigned_number
:
	UNSIGNED_INT
	| UNSIGNED_REAL
;

// --------------------------------------------
// LEXER RULES
// --------------------------------------------

/* match a concept */
CONCEPT
:
	CONCEPT_PART
	(
		'.' CONCEPT_PART
	)*
;

fragment
CONCEPT_PART
:
	(
		LETTER
		| '_'
	)
	(
		LETTER
		| '_'
		| DIGIT
	)*
;

NAME
:
	'\''
	(
		LETTER
		| DIGIT
		| '-'
		| '_'
		| '.'
	)+ '\''
;

LETTER
:
	[a-zA-Z]
;

UNSIGNED_INT
:
	DIGIT+
;

UNSIGNED_REAL
:
	DIGIT+ '.' DIGIT+
;

fragment
DIGIT
:
	[0-9]
;

/* match whitespace */
WS
:
	[ \t\r\n]+ -> skip
;

///* handle the case of a character that is not covered by the grammar. 
// * This lexer rule must be located at the end of the grammar.
// */
//UnknownCharacter
//:
//	.
//;
