GSOAP=soapcpp2
SOAPH=stdsoap2.h
SOAPC=stdsoap2.c
SOAPCPP=../../stdsoap2.cpp
CC=gcc
CPP=g++
LIBS=
COFLAGS=-O2
CWFLAGS=-Wall
CIFLAGS=-I../..
CMFLAGS=
CFLAGS= $(CWFLAGS) $(COFLAGS) $(CIFLAGS) $(CMFLAGS)
all:		calcclient calcserver
calcclient:	calc.h calcclient.cpp $(SOAPH) $(SOAPC)
		$(GSOAP) calc.h
		$(CPP) $(CFLAGS) -o calcclient calcclient.cpp soapC.cpp soapClient.cpp $(SOAPC) $(LIBS)
calcserver:	calc.h calcserver.cpp $(SOAPH) $(SOAPC)
		$(GSOAP) calc.h
		$(CPP) $(CFLAGS) -o calcserver calcserver.cpp soapC.cpp soapServer.cpp $(SOAPC) -lm $(LIBS)
clean:
		rm -f *.o soapH.h soapStub.h soapC.cpp soapC.c soapClient.cpp soapClient.c soapServer.cpp soapServer.c soap*Proxy.h
distclean:
		rm -f *.o *.wsdl *.xsd *.xml *.nsmap *.log soapH.h soapStub.h soapC.cpp soapC.c soapClient.cpp soapClient.c soapServer.cpp soapServer.c soap*Proxy.h calcclient calcserver
