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
		string timeAndDateString() const;
		void setCurrentTime();
		int dayOfWeek() const;
		int dayOfMonth() const;
		int year() const;
		int month() const;
		int hour() const;
		int minute() const;
		int second() const;
		string monthStringShort() const;
		string monthString() const;
		string dayOfWeekStringShort() const;
		string dayOfWeekString() const;
		string timeString() const;
		string dayOfMonthString() const;
		string yearString() const;
		bool operator<(const SpTime &t) const;
		bool operator==(const SpTime &t) const;
	private:
		time_t time;
};

#endif
