<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	if(request.getParameter("AuthToken").equals("12703f90fa35bb192432b274665a36f5")){
   Cookie cookie = new Cookie("TVM","Season");
   cookie.setMaxAge(365*24*60*60);
   response.addCookie(cookie);
   response.sendRedirect("tvm.jsp");
   }else{%>
   Not Authorized
   <% } %>
