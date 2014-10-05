package de.clicktt;

import java.net.URL;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

public class Newsfeed {
	public JSONObject getNews() throws Exception{
		JSONObject news = new JSONObject();
		JSONArray backlog = new JSONArray();
		JSONArray preview = new JSONArray();

		Document doc = Jsoup.parse(new URL("http://ttvwh.click-tt.de/cgi-bin/WebObjects/nuLigaTTDE.woa/wa/clubInfoDisplay?club=3968"),20000);
		String tempDay = "";
		String tempDate = "";
		// Rückschau
		for(Element row : doc.select("table.result-set").get(0).select("tr")){
			if(row.select("td").size()==12){
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
				g.put("Liga",row.select("td").get(5).text().trim());
				g.put("Heimmannschaft", row.select("td").get(6).text().trim());
				g.put("Gastmannschaft", row.select("td").get(7).text().trim());
				g.put("Spiele",row.select("td").get(8).text().trim());
				if(row.select("td").get(8).select("a").size()==1){
					g.put("Details",true);
					g.put("Detailslink", row.select("td").get(8).select("a").attr("href"));
				}else{
					g.put("Details", false);
				}
				System.out.println(g);
				backlog.add(g);
			}
		}
		// Vorschau
		System.out.println("Vorschau");
		for(Element row : doc.select("table.result-set").get(1).select("tr")){
			if(row.select("td").size()==12){
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
				g.put("Liga",row.select("td").get(5).text().trim());
				g.put("Heimmannschaft", row.select("td").get(6).text().trim());
				g.put("Gastmannschaft", row.select("td").get(7).text().trim());
				g.put("Spiele",row.select("td").get(8).text().trim());
				if(row.select("td").get(8).select("a").size()==1){
					g.put("Details",true);
				}
				preview.add(g);
			}
		}
		news.put("Backlog", backlog);
		news.put("Preview",preview);
		return news;
	}
	public static void main(String[] args) throws Exception{
		Newsfeed n = new Newsfeed();
		System.out.println(n.getNews());
	}
}
