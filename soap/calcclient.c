#include "soapH.h"
#include "calc.nsmap"

const char server[] = "http://localhost:8080";

int main(int argc, char **argv)
{ struct soap soap;
  double a, b, result;
  if (argc < 4)
  { fprintf(stderr, "Usage: [add|sub|mul|div|pow] num num\n");
    exit(0);
  }
  soap_init(&soap);
  a = strtod(argv[2], NULL);
  b = strtod(argv[3], NULL);
  switch (*argv[1])
  { case 'a':
      soap_call_ns__add(&soap, server, "", a, b, &result);
      break;
    case 's':
      soap_call_ns__sub(&soap, server, "", a, b, &result);
      break;
    case 'm':
      soap_call_ns__mul(&soap, server, "", a, b, &result);
      break;
    case 'd':
      soap_call_ns__div(&soap, server, "", a, b, &result);
      break;
    case 'p':
      soap_call_ns__pow(&soap, server, "", a, b, &result);
      break;
    default:
      fprintf(stderr, "Unknown command\n");
      exit(0);
  }
  if (soap.error)
    soap_print_fault(&soap, stderr);
  else
    printf("result = %g\n", result);
  return 0;
}
