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

int ns__sub(struct soap *soap, double a, double b, double *result)
{
	*result = a - b;
	return SOAP_OK;
} 

int ns__mul(struct soap *soap, double a, double b, double *result)
{
	*result = a * b;
	return SOAP_OK;
} 

int ns__div(struct soap *soap, double a, double b, double *result)
{
	if (b)
		*result = a / b;
	else {
		char *s = (char*)soap_malloc(soap, 1024);
		sprintf(s, "Can't divide %f by %f", a, b);
		return soap_receiver_fault(soap, "Division by zero", s);
	}
	return SOAP_OK;
} 

int ns__pow(struct soap *soap, double a, double b, double *result)
{
	*result = pow(a, b);
	/* soap_errno is like errno, but compatible with Win32 */
	if (soap_errno == EDOM) {
		char *s = (char*)soap_malloc(soap, 1024);
		sprintf(s, "Can't take the power of %f to %f", a, b);
		return soap_receiver_fault(soap, "Power function domain error", s);
	}
	return SOAP_OK;
} 
