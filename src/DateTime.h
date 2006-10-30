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
// $Id: DateTime.h,v 1.7 2003/01/28 23:23:30 mlandauer Exp $

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
	std::string getTimeAndDateString() const;
    
	//! Returns the number of days since the last sunday as an integer
	/*!
		In other words, Sun = 0, Mon = 1, Tue = 2, Wed = 3, Thu = 4, Fri = 5, Sat = 6
	*/
	int getDayOfWeek() const;
    
	//! Returns the day in the month as an integer
	/*!
		For the time Fri Dec 13 15:57:28 2002 this returns 13.
	*/
	int getDayOfMonth() const;
    
	//! Returns the year as an integer
	/*!
		For the time Fri Dec 13 15:57:28 2002 this returns 2002.
	*/
	int getYear() const;
    
	//! Returns the number of months since the last december as an integer
	/*!
		In other words, Jan = 1, Feb = 2, Mar = 3, etc...
	*/
	int getMonth() const;
    
	//! Returns the hour as an integer
	/*!
		For the time Fri Dec 13 15:57:28 2002 this returns 15.
	*/
	int getHour() const;
    
	//! Returns the minutes as an integer
	/*!
		For the time Fri Dec 13 15:57:28 2002 this returns 57.
	*/
	int getMinute() const;
    
	//! Returns the seconds as an integer
	/*!
		For the time Fri Dec 13 15:57:28 2002 this returns 28.
	*/
	int getSecond() const;
    
	//! Returns a short form of monthString()
	std::string getMonthStringShort() const;
	//! Returns the months as a string
	std::string getMonthString() const;
	//! Returns a short form of dayOfWeekString()
	std::string getDayOfWeekStringShort() const;
	//! Returns the day of the week as a string
	std::string getDayOfWeekString() const;
	//! Returns the time as a string
	std::string getTimeString() const;
	//! Returns the day of the month as a string
	std::string getDayOfMonthString() const;
	//! Returns the year as a string
	std::string getYearString() const;
	bool operator<(const DateTime &t) const;
	bool operator>(const DateTime &t) const;
	bool operator==(const DateTime &t) const;
	
private:
	time_t time;
};

}

#endif
