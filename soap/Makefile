all: simpleclient simpleserver

simpleclient: simpleclient.cpp
	g++ -o simpleclient simpleclient.cpp -leasysoap

simpleserver: simpleserver.cpp calchandler.h
	g++ -o simpleserver simpleserver.cpp -leasysoap
