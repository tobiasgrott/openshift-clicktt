package de.clicktt;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.net.ssl.HttpsURLConnection;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class Notification {
	private final static String GCM_URL="https://android.googleapis.com/gcm/send";
	private final static String GCM_API_KEY="AIzaSyB_VVDSBA8klbL2VGzULbKwnPqAUheF27M";
	public static String sendPushNotification(List<String> registrationIds, JSONObject message) throws Exception{
		URL url = new URL(GCM_URL);
		HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
		con.setRequestMethod("POST");
		con.setRequestProperty("Authorization", "key="+GCM_API_KEY);
		con.setRequestProperty("Content-Type","application/json");
		con.setDoInput(true);
		con.setDoOutput(true);
		// Creation of JSNON Object
		JSONObject o = new JSONObject();
		JSONArray regIds = new JSONArray();
		for(String regId : registrationIds){
			regIds.add(regId);
		}
		o.put("registration_ids", regIds);
		o.put("data",message);
		
		DataOutputStream output = null;
		
		output = new DataOutputStream(con.getOutputStream());
		output.writeBytes(o.toJSONString());
		output.flush();
		output.close();
 
		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();
 
		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();
 
		//print result
		return response.toString();
	}
	public static String register(String name, String email, String regId) throws Exception{
		if(name != null && email != null && regId != null){
			User u = new User();
			u.setName(name);
			u.setEmail(email);
			u.setGcmRegId(regId);
			u.store();
			
			List<String> regIds = new ArrayList<String>();
			regIds.add(regId);
			
			JSONObject msg = new JSONObject();
			msg.put("product", "shirt");
			return sendPushNotification(regIds, msg);
		}else{
			return "User details not found";
		}
	}
}
