#include <iostream>
#include "soapcalcProxy.h"
#include "calc.nsmap"

int main(int argc, char **argv)
{
	if (argc < 4) {
		std::cerr << "Usage: [add|sub|mul|div|pow] num num" << std::endl;
		exit(0);
	}
	calc c;
	double a = strtod(argv[2], NULL);
	double b = strtod(argv[3], NULL);
	double result;
	switch (*argv[1]) {
		case 'a':
			c.add(a, b, &result);
			break;
		case 's':
			c.sub(a, b, &result);
			break;
		case 'm':
			c.mul(a, b, &result);
			break;
		case 'd':
			c.div(a, b, &result);
			break;
		case 'p':
			c.pow(a, b, &result);
			break;
		default:
			std::cerr << "Unknown command" << std::endl;
			exit(0);
	}
	if (c.soap->error)
		soap_print_fault(c.soap, stderr);
	else
		std::cout << "result = " << result << std::endl;
	return 0;
}
