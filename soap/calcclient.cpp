#include "soapcalcProxy.h"
#include "calc.nsmap"

const char server[] = "http://localhost:8080";

int main(int argc, char **argv)
{
  double a, b, result;
  if (argc < 4)
  { fprintf(stderr, "Usage: [add|sub|mul|div|pow] num num\n");
    exit(0);
  }
  calc c;
  a = strtod(argv[2], NULL);
  b = strtod(argv[3], NULL);
  switch (*argv[1])
  { case 'a':
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
      fprintf(stderr, "Unknown command\n");
      exit(0);
  }
  if (c.soap->error)
    soap_print_fault(c.soap, stderr);
  else
    printf("result = %g\n", result);
  return 0;
}
