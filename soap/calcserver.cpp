#include <iostream>
#include "soapH.h"
#include "calc.nsmap"

int main(int argc, char **argv)
{
	struct soap soap;
	soap_init(&soap);
	int m = soap_bind(&soap, NULL, 8080, 100);
	if (m < 0) {
		soap_print_fault(&soap, stderr);
		exit(-1);
	}
	std::cerr << "Socket connection successful: master socket = " << m << std::endl;
	for ( ; ; ) {
		int s = soap_accept(&soap);
		std::cerr << "Socket connection successful: slave socket = " << s << std::endl;
		if (s < 0)  {
			soap_print_fault(&soap, stderr);
			exit(1);
		} 
		soap_serve(&soap);
		soap_end(&soap);
    }
	return 0;
} 

int ns__add(struct soap *soap, double a, double b, double *result)
{
	*result = a + b;
	return SOAP_OK;
} 
