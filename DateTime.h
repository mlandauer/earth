//  Copyright (C) 2001-2003 Matthew Landauer. All Rights Reserved.
//  
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of version 2 of the GNU General Public License as
//  published by the Free Software Foundation.
//
//  This program is distributed in the hope that it would be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  Further, any
//  license provided herein, whether implied or otherwise, is limited to
//  this program in accordance with the express provisions of the GNU
//  General Public License.  Patent licenses, if any, provided herein do not
//  apply to combinations of this program with other product or programs, or
//  any other product whatsoever.  This program is distributed without any
//  warranty that the program is delivered free of the rightful claim of any
//  third person by way of infringement or the like.  See the GNU General
//  Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write the Free Software Foundation, Inc., 59
//  Temple Place - Suite 330, Boston MA 02111-1307, USA.
//
// $Id$

// Basic class for keeping track of date and time stuff, comparing dates,
// making it all human readable but doing this in a way that the unix
// specific code (relating to time and date) is wrapped up in this class.

#ifndef _datetime_h_
#define _datetime_h_

#include <time.h>
#include <string>

namespace Sp {

//! Utility class that stores a date and time
class DateTime
{
public:
	DateTime();
	//! Construct date and time from a unix time
	static DateTime unixDateTime(time_t t);
	//! Return the current date and time
	static DateTime current();
    
	//! Wait a given number of seconds
	static void sleep(int seconds);
    
	//! Returns the time and date as a string
	/*!
		The string has the following format: Fri Dec 13 15:57:28 2002
	*/
	std::string timeAndDateString() const;
    
	//! Returns the number of days since the last sunday as an integer
	/*!
		In other words, Sun = 0, Mon = 1, Tue = 2, Wed = 3, Thu = 4, Fri = 5, Sat = 6
	*/
	int dayOfWeek() const;
    
	//! Returns the day in the month as an integer
	/*!
		For the time Fri Dec 13 15:57:28 2002 this returns 13.
	*/
	int dayOfMonth() const;
    
	//! Returns the year as an integer
	/*!
		For the time Fri Dec 13 15:57:28 2002 this returns 2002.
	*/
	int year() const;
    
	//! Returns the number of months since the last december as an integer
	/*!
		In other words, Jan = 1, Feb = 2, Mar = 3, etc...
	*/
	int month() const;
    
	//! Returns the hour as an integer
	/*!
		For the time Fri Dec 13 15:57:28 2002 this returns 15.
	*/
	int hour() const;
    
	//! Returns the minutes as an integer
	/*!
		For the time Fri Dec 13 15:57:28 2002 this returns 57.
	*/
	int minute() const;
    
	//! Returns the seconds as an integer
	/*!
		For the time Fri Dec 13 15:57:28 2002 this returns 28.
	*/
	int second() const;
    
	//! Returns a short form of monthString()
	std::string monthStringShort() const;
	//! Returns the months as a string
	std::string monthString() const;
	//! Returns a short form of dayOfWeekString()
	std::string dayOfWeekStringShort() const;
	//! Returns the day of the week as a string
	std::string dayOfWeekString() const;
	//! Returns the time as a string
	std::string timeString() const;
	//! Returns the day of the month as a string
	std::string dayOfMonthString() const;
	//! Returns the year as a string
	std::string yearString() const;
	bool operator<(const DateTime &t) const;
	bool operator==(const DateTime &t) const;
	
private:
	time_t time;
};

}

#endif
