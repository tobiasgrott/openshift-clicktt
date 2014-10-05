<%@ page import="de.clicktt.*" language="java"
	contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	if(request.getParameter("id")!=null){
		League l = new League(Integer.parseInt(request.getParameter("id")));
		response.getWriter().print(l.getSchedule().toJSONString());
	}
%>