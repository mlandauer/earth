#include <iostream>
#include "soapcalcProxy.h"
#include "calc.nsmap"

int main(int argc, char **argv)
{
	calc c;
	double result;
	c.add(2, 15, &result);
	
	if (c.soap->error)
		soap_print_fault(c.soap, stderr);
	else
		std::cout << "2 + 15 = " << result << std::endl;

	return 0;
}
