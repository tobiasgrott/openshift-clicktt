package de.clicktt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.google.android.gcm.server.Message;
import com.google.android.gcm.server.Result;
import com.google.android.gcm.server.Sender;

public class PushService {
	public Connection conn = null;

	public String push(int liga, String name) throws IOException {
		String retval = "";
		try {
			InitialContext ic = new InitialContext();
			Context initialContext = (Context) ic.lookup("java:comp/env");
			DataSource datasource = (DataSource) initialContext
					.lookup("jdbc/PostgreSQLDS");
			conn = datasource.getConnection();
			init();
		Sender sender = new Sender("AIzaSyB_VVDSBA8klbL2VGzULbKwnPqAUheF27M");
		System.out.println("Start Reading Games");
		Document doc = Jsoup
				.connect(
						"http://ttvwh.click-tt.de/cgi-bin/WebObjects/nuLigaTTDE.woa/wa/groupPage?displayTyp=rueckrunde&displayDetail=meetings&championship=SK+Bez.+LB+13%2F14&group="+liga)
				.get();
		Elements el = doc.select("table.result-set tr");
		int i = 0;
		for (Element e : el) {
			if (e.select("td").size() == 10 && e.select("td a").size() == 1) {
				// System.out.println(e);
				int spielnr = Integer.parseInt(e.select("td").get(4).text()
						.trim());
				String heim = e.select("td").get(5).text().trim();
				String gast = e.select("td").get(6).text().trim();
				String ergebnis = e.select("td a").get(0).text().trim();
				System.out.println("Spielnr: -" + spielnr + "-");
				System.out.println("Heim: -" + heim + "-");
				System.out.println("Gast: -" + gast + "-");
				System.out.println("Ergebnis: -" + ergebnis + "-");
				if (!existsResult(liga, spielnr)) {
					Message message = new Message.Builder()
							.addData("Liga", name).addData("Heim", heim)
							.addData("Gast", gast)
							.addData("Ergebnis", ergebnis).build();
					Result result = sender
							.send(message,
									"APA91bHQilm6R0fV1RZfx_OXRYEDSpFC9a7iBaFjoUGeWcNLF4agjaf_HvYA7cnRV7YX_k06aVQqb5i1dFe8R0PsYPn3ZVkaVo3NEnGyhWxsWSxYnLH9_mpVGM0GIRzW9aejXUO3KvnN2KkTqH8FdlOpaE5lkEZcug",
									1);
					System.out.println(result.toString());
					retval += "Spielnr: "+spielnr+ " - Heim: "+ heim+ "- Gast: "+gast+" - Ergebnis: "+ergebnis;					
					insertResult(liga, spielnr, heim, gast, ergebnis);
					i++;
					if (i > 5) {
						break;
					}
				}
			}}
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return retval;
	}

	private boolean existsResult(int liga, int spielnr) throws Exception {
		String sql = "SELECT COUNT(*) FROM games where liga=? AND spielnr=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, liga);
		stmt.setInt(2, spielnr);
		ResultSet rs = stmt.executeQuery();
		rs.next();
		int exists = rs.getInt(1);
		rs.close();
		stmt.close();
		if (exists == 0) {
			return false;
		} else {
			return true;
		}
	}

	private void insertResult(int liga, int spielnr, String heim, String gast,
			String ergebnis) throws Exception {
		String sql = "INSERT INTO games (liga,spielnr,heim,gast,ergebnis) VALUES (?,?,?,?,?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, liga);
		stmt.setInt(2, spielnr);
		stmt.setString(3, heim);
		stmt.setString(4, gast);
		stmt.setString(5, ergebnis);
		stmt.executeUpdate();
		stmt.close();
	}

	private void init() throws Exception {
		DatabaseMetaData meta = conn.getMetaData();
		ResultSet res = meta.getTables(null, null, "spiele",
				new String[] { "TABLE" });
		if (!res.next()) {
			String sql = "CREATE TABLE games (liga integer, spielnr integer,heim varchar(200), gast varchar(200), ergebnis varchar(10))";
			Statement stmt = conn.createStatement();
			stmt.execute(sql);
			stmt.close();
		}
	}
}