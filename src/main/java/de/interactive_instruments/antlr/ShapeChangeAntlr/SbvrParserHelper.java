/**
 * ShapeChange Antlr Parser Generator
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
package de.interactive_instruments.antlr.ShapeChangeAntlr;

import java.util.HashSet;
import java.util.Set;

/**
 * An SbvrParserHelper is used when parsing SBVR constraints. It's methods are
 * called to identify if a given concept is a noun or a verb defined by the
 * conceptual model.
 * 
 * @author Johannes Echterhoff
 *
 */
public class SbvrParserHelper {

	/**
	 * Contains all nouns defined in the model Must be set externally before
	 * parsing SBVR constraints.
	 */
	public Set<String> nouns = new HashSet<String>();

	/**
	 * Contains all verbs defined in the model Must be set externally before
	 * parsing SBVR constraints.
	 */
	public Set<String> verbs = new HashSet<String>();

	/**
	 * Determines whether or not the given token is a noun defined by the model.
	 * If the token is a sequence of parts, separated by dots, then each part is
	 * checked. A noun must be a name contained in the {@link #nouns} set; case
	 * matters.
	 * 
	 * @param token
	 * @return <code>true</code> if the given token is a valid noun, else
	 *         <code>false</code>
	 */
	public boolean isNoun(String token) {

		boolean result = true;

		if (token.contains(".")) {

			String[] parts = token.split("\\.");

			for (String part : parts) {

				if (part.length() > 0
						&& !(nouns.contains(part) || nouns.contains(part
								+ "TimeSlice"))) {
					result = false;
				}
			}

		} else {

			if (!(nouns.contains(token) || nouns.contains(token + "TimeSlice"))) {
				result = false;
			}
		}

		return result;
	}

	/**
	 * Determines whether or not the given token is a verb defined by the model.
	 * A verb must be a name contained in the {@link #verbs} set; case matters.
	 * 
	 * @param token
	 * @return <code>true</code> if the given token is a valid verb, else
	 *         <code>false</code>
	 */
	public boolean isVerb(String token) {

		if (!verbs.contains(token)) {
			return false;
		} else {
			return true;
		}
	}
}
