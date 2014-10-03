package de.clicktt;

import java.net.URL;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.nodes.TextNode;

public class League {
	private int groupId;
	
	public League(int groupId){
		this.groupId = groupId;
	}
	
	public JSONArray getTable() throws Exception{
		JSONArray table = new JSONArray();
		Document doc = Jsoup.parse(new URL("http://ttvwh.click-tt.de/cgi-bin/WebObjects/nuLigaTTDE.woa/wa/groupPage?championship=SK+Bez.+LB+14%2F15&group="+this.groupId),20000);
		for(Element row : doc.select("table.result-set tr")){
			if(row.select("td").size()==10){
				JSONObject r = new JSONObject();
				if(row.select("img[alt=Aufsteiger]").size()>0){
					r.put("Aufsteiger", true);
				}else{
					r.put("Aufsteiger", false);
				}
				if(row.select("img[alt=Absteiger]").size()>0){
					r.put("Absteiger", true);
				}else{
					r.put("Absteiger", false);
				}
				r.put("Rang", Integer.parseInt(row.select("td").get(1).text().trim()));
				r.put("Team", row.select("td").get(2).text().trim());
				r.put("Begegnungen", Integer.parseInt(row.select("td").get(3).text().trim()));
				r.put("S",Integer.parseInt(row.select("td").get(4).text().trim()));
				r.put("U", Integer.parseInt(row.select("td").get(5).text().trim()));
				r.put("N",Integer.parseInt(row.select("td").get(6).text().trim()));
				r.put("Spiele",row.select("td").get(7).text().trim());
				r.put("Diff", Integer.parseInt(row.select("td").get(8).text().trim()));
				r.put("Punkte",row.select("td").get(9).text().trim());
				table.add(r);
			}
		}
		return table;
	}
	public JSONArray getSchedule() throws Exception{
		JSONArray schedule = new JSONArray();
		Document doc = Jsoup.parse(new URL("http://ttvwh.click-tt.de/cgi-bin/WebObjects/nuLigaTTDE.woa/wa/groupPage?displayTyp=vorrunde&displayDetail=meetings&championship=SK+Bez.+LB+14%2F15&group="+this.groupId),20000);
		String tempDay = "";
		String tempDate = "";
		for(Element row : doc.select("table.result-set tr")){
			if(row.select("td").size()==11){
				JSONObject g = new JSONObject();
				if(row.select("td").get(0).text().trim().length()>=3){
					tempDay = row.select("td").get(0).text().trim();
				}
				if(row.select("td").get(1).text().trim().length()>=10){
					tempDate = row.select("td").get(1).text().trim();
				}
					
				g.put("Tag", tempDay);
				g.put("Datum", tempDate.substring(0,6));
				g.put("Zeit", row.select("td").get(2).text().trim());
				g.put("Halle", row.select("td").get(3).text().trim());
				g.put("Nr", Integer.parseInt(row.select("td").get(4).text().trim()));
				g.put("Heimmannschaft", row.select("td").get(5).text().trim());
				g.put("Gastmannschaft", row.select("td").get(6).text().trim());
				g.put("Spiele",row.select("td").get(7).text().trim());
				if(row.select("td").get(7).select("a").size()==1){
					g.put("Details",true);
				}
				schedule.add(g);
			}
		}
		return schedule;
	}
	public JSONArray getLineUp() throws Exception{
		JSONArray lineup  = new JSONArray();
		Document doc = Jsoup.parse(new URL("http://ttvwh.click-tt.de/cgi-bin/WebObjects/nuLigaTTDE.woa/wa/groupPools?displayTyp=vorrunde&championship=SK+Bez.+LB+14%2F15&group="+this.groupId),20000);
		String tempTeam = "";
		JSONObject tJS = null;
		JSONArray tLineup = null;
		for(Element row : doc.select("table.result-set tr")){
			if(row.select("h2").size()==1){
				if(tJS != null){
					tJS.put("LineUp", tLineup);
					lineup.add(tJS);
				}
				tJS = new JSONObject();
				tJS.put("Team", row.select("h2").text().trim());
				tLineup = new JSONArray();
			}else if(row.select("td").size()==5){
				JSONObject tPlayer = new JSONObject();
				tPlayer.put("Rang", row.select("td").get(0).text().trim());
				tPlayer.put("TTR", row.select("td").get(1).text().trim());
				tPlayer.put("Name", row.select("td").get(2).text().trim());
				if(row.select("td").get(4).text().contains("Jugendersatzspieler")){
					tPlayer.put("JES",true);
				}else{
					tPlayer.put("JES",false);
				}
				if(row.select("td").get(4).text().contains("Markierter Spieler")){
					tPlayer.put("markiert", true);
				}else{
					tPlayer.put("markiert", false);
				}
				if(row.select("td").get(4).text().contains("Reserverspieler")){
					tPlayer.put("Reserve",true);
				}else{
					tPlayer.put("Reserve",false);
				}
				tLineup.add(tPlayer);
			}
		}
		tJS.put("LineUp", tLineup);
		lineup.add(tJS);
		return lineup;
	}
	public JSONArray getGyms() throws Exception{
		JSONArray gyms = new JSONArray();
		Document doc = Jsoup.parse(new URL("http://ttvwh.click-tt.de/cgi-bin/WebObjects/nuLigaTTDE.woa/wa/groupInfo?contentType=teamContacts&championship=SK+Bez.+LB+14%2F15&group="+this.groupId),20000);
		for(Element e : doc.select(".text-block-2col div")){
			JSONObject team = new JSONObject();
			team.put("Team", e.select("h2").get(0).text().trim());
			JSONArray hallen = new JSONArray();
			for(Element li : e.select("li")){
				if(li.text().trim().contains("Spiellokal") && li.select("address").get(0).childNodeSize()>2){
					JSONObject gym = new JSONObject();
					gym.put("Nr", li.childNodes().get(0).toString().trim());
					gym.put("Name",(((TextNode) li.select("address").get(0).childNodes().get(0))).text().trim());

					String adresse = (((TextNode) li.select("address").get(0).childNodes().get(2))).text().trim();
					gym.put("Strasse", adresse.split(",")[0].trim());
					if(adresse.split(",").length>1){
						gym.put("Ort",adresse.split(",")[1].trim());
					}else{
						gym.put("Ort", "not available");
					}
					hallen.add(gym);
				}
			}
			team.put("Hallen",hallen);
			gyms.add(team);
		}
		return gyms;
	}
	public static void main(String[] args) throws Exception{
		League  l = new League(226372); // Kreisliga
//		System.out.println(l.getTable().toJSONString());
//		System.out.println(l.getSchedule().toJSONString());
//		System.out.println(l.getLineUp().toJSONString());
		System.out.println(l.getGyms().toJSONString());
		l = new League(226391); // B-Klasse
//		System.out.println(l.getTable().toJSONString());
//		System.out.println(l.getSchedule().toJSONString());
//		System.out.println(l.getLineUp().toJSONString());
		System.out.println(l.getGyms().toJSONString());		
		l = new League(230228); // D-Klasse
//		System.out.println(l.getTable().toJSONString());
//		System.out.println(l.getSchedule().toJSONString());
//		System.out.println(l.getLineUp().toJSONString());
		System.out.println(l.getGyms().toJSONString());
		l = new League(226469); // Kids 1
//		System.out.println(l.getTable().toJSONString());
//		System.out.println(l.getSchedule().toJSONString());
//		System.out.println(l.getLineUp().toJSONString());
		System.out.println(l.getGyms().toJSONString());		
		l = new League(226381); // Kids 2
//		System.out.println(l.getTable().toJSONString());
//		System.out.println(l.getSchedule().toJSONString());
//		System.out.println(l.getLineUp().toJSONString());
		System.out.println(l.getGyms().toJSONString());		
	}
}
