// $Id$

#include "SpTime.h"

SpTime::SpTime()
{
}

SpTime::~SpTime()
{
}

void SpTime::setUnixTime(time_t t)
{
	time = t;
}

SpString SpTime::string()
{
	SpString dayOfMonthString, yearString;
	dayOfMonthString.setNum(dayOfMonth());
	yearString.setNum(year());
	SpString s = dayOfWeekStringShort() + " " + monthStringShort() + " " +
		dayOfMonthString + " " + timeString() + " " + yearString;
	return s;
}

// What happens to all these pointers that are returned??

// Sun = 0, Mon = 1, Tue = 2, Wed = 3, Thu = 4, Fri = 5, Sat = 6
int SpTime::dayOfWeek()
{
	struct tm *localtime = std::localtime(&time);
	return (localtime->tm_wday);
}

int SpTime::dayOfMonth()
{
	struct tm *localtime = std::localtime(&time);
	return (localtime->tm_mday);
}

int SpTime::year()
{
	struct tm *localtime = std::localtime(&time);
	return (1900 + localtime->tm_year);
}

// Jan = 1, Feb = 2, Mar = 3, etc...
int SpTime::month()
{
	struct tm *localtime = std::localtime(&time);
	return (1 + localtime->tm_mon);
}

SpString SpTime::dayOfWeekStringShort()
{
	SpString s = dayOfWeekString();
	s.truncate(3);
	return (s);
}

SpString SpTime::timeString()
{
	SpString s;
	s.sprintf("%02i:%02i:%02i", hour(), minute(), second());
	return (s);
}

SpString SpTime::dayOfWeekString()
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

SpString SpTime::monthStringShort()
{
	SpString s = monthString();
	s.truncate(3);
	return (s);
}

SpString SpTime::monthString()
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

int SpTime::hour()
{
	struct tm *localtime = std::localtime(&time);
	return (localtime->tm_hour);
}

int SpTime::minute()
{
	struct tm *localtime = std::localtime(&time);
	return (localtime->tm_min);
}

int SpTime::second()
{
	struct tm *localtime = std::localtime(&time);
	return (localtime->tm_sec);
}

void SpTime::setCurrentTime()
{
	time = std::time(NULL);
}
