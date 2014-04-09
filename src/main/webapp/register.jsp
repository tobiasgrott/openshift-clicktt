<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="de.clicktt.*,java.util.*,org.json.simple.*"%><%

    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String regId = request.getParameter("regId");
    String result = "";
    if(name!=null&& email !=null&&regId!=null){
    	GCMUser u = new GCMUser();
    	u.setEmail(email);
    	u.setGcmRegId(regId);
    	u.setName(name);
    	u.store();
    	
    	List<String> registrationIds = new ArrayList<String>();
    	registrationIds.add(regId);
    	
    	JSONObject message = new JSONObject();
    	message.put("product","shirt");
    	
    	result = Notification.sendPushNotification(registrationIds, message);
    }else{
    	result = "User Details not found";
    }
    %><%= result %>