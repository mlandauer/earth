GSOAP=soapcpp2
SOAPH=stdsoap2.h
SOAPCPP=stdsoap2.cpp
CPP=g++
LIBS=
CFLAGS= -Wall -O2

all:		calcclient calcserver

calcclient:	calc.h calcclient.cpp $(SOAPH) $(SOAPCPP)
		$(GSOAP) calc.h
		$(CPP) $(CFLAGS) -o calcclient calcclient.cpp soapC.cpp soapClient.cpp $(SOAPCPP) $(LIBS)
		
calcserver:	calc.h calcserver.cpp $(SOAPH) $(SOAPCPP)
		$(GSOAP) calc.h
		$(CPP) $(CFLAGS) -o calcserver calcserver.cpp soapC.cpp soapServer.cpp $(SOAPCPP) -lm $(LIBS)

clean:
		rm -f *.o soapH.h soapStub.h soapC.cpp soapClient.cpp soapServer.cpp soap*Proxy.h

distclean:
		rm -f *.o *.wsdl *.xsd *.xml *.nsmap *.log soapH.h soapStub.h soapC.cpp soapClient.cpp soapServer.cpp soap*Proxy.h calcclient calcserver
