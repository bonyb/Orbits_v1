package com.node.utilities;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class UtilityFunctionsImpl {

	/**
	 * To allow apostrophes in the text
	 * 
	 * @param textArg1
	 * @param textArg2
	 * @return
	 */
	public String[] setEcsapeTitleDesc(String textArg1, String textArg2) {
		if (!textArg1.isEmpty()) {
			StringBuilder titleEscape = new StringBuilder(textArg1);
			int index = titleEscape.indexOf("'");
			while (index > 0) {
				titleEscape.insert(index, '\'');
				index = titleEscape.indexOf("'", index + 2);
			}
			textArg1 = titleEscape.toString();
		}

		if (textArg2 != null) {
			StringBuilder descEscape = new StringBuilder(textArg2);
			int indexd = descEscape.indexOf("'");
			while (indexd > 0) {
				descEscape.insert(indexd, '\'');
				indexd = descEscape.indexOf("'", indexd + 2);
			}
			textArg2 = descEscape.toString();

		}
		String[] escapetexts = { textArg1, textArg2 };
		return escapetexts;
	}

	/**
	 * To get the current date time and convert it to the correct format for
	 * saving in the DB
	 * 
	 * @return
	 * @throws ParseException
	 */
	public String getCuttentDateTime() throws ParseException {
		// SimpleDateFormat ft = new SimpleDateFormat
		// ("dd MMM yyyy hh:mm:ss a ");
		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// String curr= new Date().toString();
		String curr = ft.format(new Date());
		// System.out.println(curr);
		return curr;

	}

	/**
	 * TO display the date & time in a particular for the JSP page
	 * 
	 * @param result
	 * @return
	 * @throws SQLException
	 */
	public String setDisplayTime(String dt) throws SQLException {

		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String curr = new String();
		try {
			// parset the string and create date object
			Date t = ft.parse(dt);

			// to format the date in the desired format
			SimpleDateFormat newft = new SimpleDateFormat(
					"dd MMM yyyy hh:mm:ss a ");
			curr = newft.format(t);
			// System.out.println(curr);
		} catch (ParseException e) {
			System.out.println("Unparseable using " + ft);
		}
		return curr;

	}

}
