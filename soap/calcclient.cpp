#include <iostream>
#include "soapcalcProxy.h"
#include "calc.nsmap"

int main(int argc, char **argv)
{
	calc c;
	struct ns__getDimResponse result;
	c.getDim(NULL, &result);
	
	if (c.soap->error)
		soap_print_fault(c.soap, stderr);
	else
		std::cout << "width, height = " << result.return_.width << ", " << result.return_.height << std::endl;

	return 0;
}
