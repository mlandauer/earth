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

#include <string>
#include <strstream>
#include <iomanip>
#include <unistd.h>

#include "SpTime.h"

SpTime::SpTime() : time(0)
{
}

SpTime::~SpTime()
{
}

// Wait for an approximate amount of time
void SpTime::sleep(int seconds)
{
	::sleep(seconds);
}

bool SpTime::operator<(const SpTime &t) const
{
	return (time < t.time);
}

bool SpTime::operator==(const SpTime &t) const
{
	return (time == t.time);
}

void SpTime::setUnixTime(time_t t)
{
	time = t;
}

std::string SpTime::timeAndDateString() const
{
	std::string s = dayOfWeekStringShort() + " " + monthStringShort() + " " +
		dayOfMonthString() + " " + timeString() + " " + yearString();
	return s;
}

std::string SpTime::dayOfMonthString() const
{
	char buf[100];
	std::string s;
	std::strstream o(buf, 100);
	o << dayOfMonth();
	o >> s;
	return (s);
}

std::string SpTime::yearString() const
{
	std::string s;
	char buf[100];
	std::strstream o(buf, 100);
	o << year();
	o >> s;
	return (s);
}

// What happens to all these pointers that are returned??

// Sun = 0, Mon = 1, Tue = 2, Wed = 3, Thu = 4, Fri = 5, Sat = 6
int SpTime::dayOfWeek() const
{
	struct tm *localtime = std::localtime(&time);
	return (localtime->tm_wday);
}

int SpTime::dayOfMonth() const
{
	struct tm *localtime = std::localtime(&time);
	return (localtime->tm_mday);
}

int SpTime::year() const
{
	struct tm *localtime = std::localtime(&time);
	return (1900 + localtime->tm_year);
}

// Jan = 1, Feb = 2, Mar = 3, etc...
int SpTime::month() const
{
	struct tm *localtime = std::localtime(&time);
	return (1 + localtime->tm_mon);
}

std::string SpTime::dayOfWeekStringShort() const
{
	std::string s = dayOfWeekString();
	s.resize(3);
	return (s);
}

std::string SpTime::timeString() const
{
	std::string s;
	char buf[100];
	std::strstream o(buf, 100);
	o << std::setfill('0')
	  << std::setw(2) << hour() << ":"
	  << std::setw(2) << minute() << ":"
	  << std::setw(2) << second();
	o >> s;
	return (s);
}

std::string SpTime::dayOfWeekString() const
{
	switch (dayOfWeek())
	{
		case 0:
			return ("Sunday");
		case 1:
			return ("Monday");
		case 2:
			return ("Tuesday");
		case 3:
			return ("Wednesday");
		case 4:
			return ("Thursday");
		case 5:
			return ("Friday");
		case 6:
			return ("Saturday");
    default:
      assert(false);
	}
}

std::string SpTime::monthStringShort() const
{
	std::string s = monthString();
	s.resize(3);
	return (s);
}

std::string SpTime::monthString() const
{
	switch (month()) {
		case 1:
			return ("January");
		case 2:
			return ("February");
		case 3:
			return ("March");
		case 4:
			return ("April");
		case 5:
			return ("May");
		case 6:
			return ("June");
		case 7:
			return ("July");
		case 8:
			return ("August");
		case 9:
			return ("September");
		case 10:
			return ("October");
		case 11:
			return ("November");
		case 12:
			return ("December");
    default:
      assert(false);
	}
}

int SpTime::hour() const
{
	struct tm *localtime = std::localtime(&time);
	return (localtime->tm_hour);
}

int SpTime::minute() const
{
	struct tm *localtime = std::localtime(&time);
	return (localtime->tm_min);
}

int SpTime::second() const
{
	struct tm *localtime = std::localtime(&time);
	return (localtime->tm_sec);
}

void SpTime::setCurrentTime()
{
	time = std::time(NULL);
}
