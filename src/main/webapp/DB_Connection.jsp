%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII"%>
<%@ page import='java.sql.*' %>
<%@ page import='javax.sql.*' %>
<%@ page import='javax.naming.*' %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>JBOSS Application Server 7 &amp; JBOSS EAP</title>
</head>
<body>
<%
Connection result = null;
try {
    Context initialContext = new InitialContext();
    DataSource datasource = (DataSource)initialContext.lookup("java:jboss/datasources/MysqlDS");
    result = datasource.getConnection();
    Statement stmt = result.createStatement() ;
    String query = "select * from names;" ;
    ResultSet rs = stmt.executeQuery(query) ;
    while (rs.next()) {
        out.println(rs.getString(1) + " " + rs.getString(2) + " " + rs.getString(3) + "<br />");
    }
} catch (Exception ex) {
    out.println("Exception: " + ex + ex.getMessage());
}
%>
</body>
</html>
Tomcat 6 (JBoss EWS 1.0) / Tomcat 7 (JBoss EWS 2.0) Example
This example applies to the jbossews-1.0 and jbossews-2.0 cartridges. If you want to use PostgreSQL instead of MySQL, replace the 'MysqlDS' below with 'PostgreSQLDS'.

<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII"%>
<%@ page import='java.sql.*' %>
<%@ page import='javax.sql.*' %>
<%@ page import='javax.naming.*' %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Tomcat 6 &amp; Tomcat 7 (JBOSS EWS) Example</title>
</head>
<body>
<%
Connection result = null;
try {
    InitialContext ic = new InitialContext();
    Context initialContext = (Context) ic.lookup("java:comp/env");
    DataSource datasource = (DataSource) initialContext.lookup("jdbc/PostgreSQLDS");
    result = datasource.getConnection();
    Statement stmt = result.createStatement() ;
    String query = "select * from names;" ;
    ResultSet rs = stmt.executeQuery(query) ;
    while (rs.next()) {
        out.println(rs.getString(1) + " " + rs.getString(2) + " " + rs.getString(3) + "<br />");
    }
} catch (Exception ex) {
    out.println("Exception: " + ex + ex.getMessage());
}
%>
</body>
</html>