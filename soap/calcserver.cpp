#include "soapH.h"
#include "calc.nsmap"

int main(int argc, char **argv)
{ int m, s; /* master and slave sockets */
  struct soap soap;
  soap_init(&soap);
  m = soap_bind(&soap, NULL, 8080, 100);
    if (m < 0)
    { soap_print_fault(&soap, stderr);
      exit(-1);
    }
    fprintf(stderr, "Socket connection successful: master socket = %d\n", m);
    for ( ; ; )
    { s = soap_accept(&soap);
      fprintf(stderr, "Socket connection successful: slave socket = %d\n", s);
      if (s < 0)
      { soap_print_fault(&soap, stderr);
        exit(1);
      } 
      soap_serve(&soap);
      soap_end(&soap);
    }
  return 0;
} 

int ns__add(struct soap *soap, double a, double b, double *result)
{ *result = a + b;
  return SOAP_OK;
} 

int ns__sub(struct soap *soap, double a, double b, double *result)
{ *result = a - b;
  return SOAP_OK;
} 

int ns__mul(struct soap *soap, double a, double b, double *result)
{ *result = a * b;
  return SOAP_OK;
} 

int ns__div(struct soap *soap, double a, double b, double *result)
{ if (b)
    *result = a / b;
  else
  { char *s = (char*)soap_malloc(soap, 1024);
    sprintf(s, "Can't divide %f by %f", a, b);
    return soap_receiver_fault(soap, "Division by zero", s);
  }
  return SOAP_OK;
} 

int ns__pow(struct soap *soap, double a, double b, double *result)
{ *result = pow(a, b);
  if (soap_errno == EDOM)	/* soap_errno is like errno, but compatible with Win32 */
  { char *s = (char*)soap_malloc(soap, 1024);
    sprintf(s, "Can't take the power of %f to %f", a, b);
    return soap_receiver_fault(soap, "Power function domain error", s);
  }
  return SOAP_OK;
} 
