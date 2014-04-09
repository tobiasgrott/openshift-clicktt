<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="de.clicktt.*,java.util.*,org.json.simple.*"%><%
    String regId = request.getParameter("regId");
    String pushMessage = request.getParameter("message");
    
    if(regId!=null&&pushMessage !=null){
    	List<String> registrationIds = new ArrayList<String>();
    	registrationIds.add(regId);
    	JSONObject message = new JSONObject();
    	message.put("price",pushMessage);
    	Notification.sendPushNotification(registrationIds, message);
    }
%>