<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import='de.clicktt.*' %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Tomcat 6 &amp; Tomcat 7 (JBOSS EWS) Example</title>
</head>
<body>
<%
//DBHelper.createTables();
DBHelper.insertGame(205171,"28.03.2014 19:30",1,86,"TSV Oberriexingen II","KSG Gerlingen V",9,7);
DBHelper.insertGame(205171,"29.03.2014 18:00",1,81,"SpVgg Hirschlanden-Schöckingen III","TSV Enzweihingen III",6,9);
DBHelper.insertGame(205171,"29.03.2014 18:00",1,82,"TSV Oberriexingen II","TSV Bietigheim III",9,5);
%>
<%= DBHelper.getSpieleliste(205171) %>
</body>
</html>