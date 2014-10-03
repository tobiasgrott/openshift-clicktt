<%@ page import="de.clicktt.*" language="java"
	contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	League l = new League(Integer.parseInt(request.getParameter("id")));
%><%=l.getTable().toJSONString()%>