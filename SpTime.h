//  Copyright (C) 2001 Matthew Landauer. All Rights Reserved.
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

#ifndef _sptime_h_
#define _sptime_h_

#include <time.h>
#include <string>

class SpTime
{
	public:
		SpTime();
		~SpTime();
		void setUnixTime(time_t t);
		std::string timeAndDateString() const;
		void setCurrentTime();
		int dayOfWeek() const;
		int dayOfMonth() const;
		int year() const;
		int month() const;
		int hour() const;
		int minute() const;
		int second() const;
		std::string monthStringShort() const;
		std::string monthString() const;
		std::string dayOfWeekStringShort() const;
		std::string dayOfWeekString() const;
		std::string timeString() const;
		std::string dayOfMonthString() const;
		std::string yearString() const;
		bool operator<(const SpTime &t) const;
		bool operator==(const SpTime &t) const;
		static void sleep(int seconds);
	private:
		time_t time;
};

#endif
