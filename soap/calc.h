//gsoap ns service name: calc
//gsoap ns service location: http://localhost:8080
//gsoap ns schema namespace: urn:calc

class ns__Dim
{
	int width;
	int height;
};

int ns__getDim(void *_, ns__Dim *result);
