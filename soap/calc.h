//gsoap ns service name: calc
//gsoap ns service location: http://localhost:8080
//gsoap ns schema namespace: urn:calc

class ns__Dim
{
	int width;
	int height;
};

struct ns__getDimResponse { ns__Dim return_; };

int ns__getDim(double a, double b, struct ns__getDimResponse *result);
