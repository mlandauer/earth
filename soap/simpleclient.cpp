/* 
 * EasySoap++ - A C++ library for SOAP (Simple Object Access Protocol)
 * Copyright (C) 2001 David Crowley; SciTegic, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free
 * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <easysoap/SOAP.h>

USING_EASYSOAP_NAMESPACE

//
//  The namespace for the methods we're calling.  This
//  is the same namespace defined in calchandler.h.
static const char *ns = "http://easysoap.sourceforge.net/demos/calculator";

int
main(int argc, const char *argv[])
{
	try
	{
		const char *endpoint;
		if (argc > 1)
			endpoint = argv[1];
		else
			endpoint = "http://easysoap.sourceforge.net/cgi-bin/simpleserver";

		SOAPProxy proxy(endpoint);
		SOAPMethod addmethod("add", ns);

		int a = 10;
		int b = 22;
		int n;

		addmethod.AddParameter("a") << a;
		addmethod.AddParameter("b") << b;

		const SOAPResponse& addresp = proxy.Execute(addmethod);

		addresp.GetReturnValue() >> n;

		printf("%d + %d = %d\n", a, b, n);


		SOAPMethod multmethod("mult", ns);
		multmethod.AddParameter("a") << a;
		multmethod.AddParameter("b") << b;

		const SOAPResponse& multresp = proxy.Execute(multmethod);

		multresp.GetReturnValue() >> n;

		printf("%d * %d = %d\n", a, b, n);

		return 0;
	}
	catch (SOAPException& ex)
	{
		printf("Caught SOAP exception: %s\n", ex.What().Str());
		return 1;
	}
}
