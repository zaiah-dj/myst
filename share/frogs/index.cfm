<!---
Application.cfc

Author
------n
	Antonio R. Collins II (rc@tubularmodular.com, ramar.collins@gmail.com)

Copyright
---------

	Copyright 2016-Present, "Tubular Modular"
	Original Author Date: Tue Jul 26 07:26:29 2016 -0400

Summary
-------

 	ColdMVC's index file.  The single entry point for applications
	running on this framework. 
  --->
<cfscript>
	coldmvc = createObject("component", "coldmvc").init({});
	coldmvc.make_index(coldmvc);
</cfscript>
