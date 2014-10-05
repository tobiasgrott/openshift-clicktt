<%@ page import="de.clicktt.jpa.*,de.clicktt.ejb.*" language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	Dummy d = new Dummy();	d.setId(1);	d.setText("Test1");	DummyService.save(d);
	d = new Dummy();	d.setId(2); d.setText("Test2"); DummyService.save(d);
	
	for(Dummy x : DummyService.findAll()){
		response.getWriter().print(x.getId()+" - "+x.getText()+"<br />");
	}
 %>
</body>
</html>