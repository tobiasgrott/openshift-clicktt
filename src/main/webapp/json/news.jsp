<%@ page import="de.clicktt.*" language="java"
	contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Newsfeed n = new Newsfeed();
	response.getWriter().print(n.getNews());
%>