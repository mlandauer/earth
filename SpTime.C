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

string SpTime::timeAndDateString() const
{
	string s = dayOfWeekStringShort() + " " + monthStringShort() + " " +
		dayOfMonthString() + " " + timeString() + " " + yearString();
	return s;
}

string SpTime::dayOfMonthString() const
{
	char buf[100];
	string s;
	strstream o(buf, 100);
	o << dayOfMonth();
	o >> s;
	return (s);
}

string SpTime::yearString() const
{
	string s;
	char buf[100];
	strstream o(buf, 100);
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

string SpTime::dayOfWeekStringShort() const
{
	string s = dayOfWeekString();
	s.resize(3);
	return (s);
}

string SpTime::timeString() const
{
	string s;
	char buf[100];
	strstream o(buf, 100);
	o << setfill('0')
	  << setw(2) << hour() << ":"
	  << setw(2) << minute() << ":"
	  << setw(2) << second();
	o >> s;
	return (s);
}

string SpTime::dayOfWeekString() const
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
	}
}

string SpTime::monthStringShort() const
{
	string s = monthString();
	s.resize(3);
	return (s);
}

string SpTime::monthString() const
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
