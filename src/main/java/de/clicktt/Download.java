package de.clicktt;



import java.io.IOException;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class Download {
	public static String doc(String url) throws IOException {
		Document doc = Jsoup.connect(url).get();
		return doc.html();
	}

	public static String json(String groupId) throws Exception {
		JSONObject o = new JSONObject();
		Document doc = Jsoup
				.connect(
						"http://ttvwh.click-tt.de/cgi-bin/WebObjects/nuLigaTTDE.woa/wa/groupPage?championship=SK+Bez.+LB+13%2F14&group="
								+ groupId).get();
		Elements tables = doc.select("table.result-set tbody");
		int i = 0;
		for(Element table : tables)
		{
			if(i == 0){
				JSONArray jstab = new JSONArray();
				Elements trs = table.select("tr");
				for(Element tr : trs){
					JSONObject tablerow = new JSONObject();
					if(tr.select("td").size()==10){
						// Tabellenzeile
						if(tr.select("img[title=Aufsteiger]").size()>0)
						{
							tablerow.put("Aufsteiger", true);
						}else{
							tablerow.put("Aufsteiger", false);
						}
						if(tr.select("img[title=Absteiger]").size()>0)
						{
							tablerow.put("Absteiger", true);
						}else{
							tablerow.put("Absteiger", false);
						}
						tablerow.put("Platz", Integer.parseInt(tr.select("td").get(1).text().trim()));
						tablerow.put("Team", tr.select("td").get(2).text().trim());
						tablerow.put("TeamLink", tr.select("td a").get(0).attr("href"));
						
						tablerow.put("Begegnungen", Integer.parseInt(tr.select("td").get(3).text()));
						tablerow.put("S", Integer.parseInt(tr.select("td").get(4).text()));
						tablerow.put("U", Integer.parseInt(tr.select("td").get(5).text()));
						tablerow.put("N", Integer.parseInt(tr.select("td").get(6).text()));
						
						tablerow.put("Spiele",tr.select("td").get(7).text().trim());
						tablerow.put("Spieldiff", Integer.parseInt(tr.select("td").get(8).text().replace("+","").trim()));
						tablerow.put("Punkte", tr.select("td").get(9).text().trim());
						jstab.add(tablerow);
					}
					}
				o.put("Tabelle", jstab);
			}else if(i==1){
				JSONArray jsList = new JSONArray();
				Elements trs = table.select("tr");
				String day = "";
				String date = "";
				for(Element tr : trs){
					if(tr.select("td").size() == 10){
						JSONObject s = new JSONObject();
						if(tr.select("td").get(0).text().trim().length()>0){
							day = tr.select("td").get(0).text().trim();
						}
						if(tr.select("td").get(1).text().trim().length()>0){
							date = tr.select("td").get(1).text().trim();
						}
						s.put("Spieltag", day+ " "+date+" "+tr.select("td").get(2).text().trim()+" Uhr");
						s.put("Halle", Integer.parseInt(tr.select("td").get(3).select("span").get(0).text().replace("(","").replace(")","").trim()));
						s.put("Spielnr", Integer.parseInt(tr.select("td").get(4).text().trim()));
						s.put("Heimmannschaft", tr.select("td").get(5).text().trim());
						s.put("Gastmannschaft", tr.select("td").get(6).text().trim());
						String ergebnis = tr.select("td").get(7).text().trim();
						if(ergebnis.length()>0){
							s.put("Ergebnis",ergebnis);
							s.put("ErgebnisLink", tr.select("td a").get(0).attr("href"));
						}
						jsList.add(s);
					}
				}
				o.put("Ergebnisse", jsList);
			}
			i++;
		}
		return o.toString();
	}
	EntityManagerFactory emf;
	public String testJPA(){
		String retval = "";
		emf = Persistence.createEntityManagerFactory("JPAUnit");
		try{
			DBSample s = new DBSample();
			s.setMeinText("Hallo Welt");
			createEntity(s);
			Object id = s.getId();
			
			retval += "\n--- " + readEntity(DBSample.class,id) + " ---\n";
		}finally{
			emf.close();
		}
		return retval;
	}
	public <T> void createEntity(T entity){
		EntityManager em = emf.createEntityManager();
		EntityTransaction tx = em.getTransaction();
		try{
			tx.begin();em.persist(entity);
			tx.commit();
		}catch(RuntimeException ex){
			if(tx != null && tx.isActive())tx.rollback();
			throw ex;
		}finally{
			em.close();
		}
	}
	public <T> T readEntity(Class<T> clss, Object id){
		EntityManager em = emf.createEntityManager();
		try{
			return em.find(clss,  id);
		}finally{
			em.close();
		}
	}
}
