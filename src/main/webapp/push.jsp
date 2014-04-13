<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="de.clicktt.*"%><%
PushService p = new PushService();
    p.delete();
%> 
<%= p.push(205171,"C-Klasse") %>
<% // p.push(204668,"Bezirksklasse") %>
<% // p.push(205175,"D-Klasse") %>
<% // p.push(204564,"Kids") %>