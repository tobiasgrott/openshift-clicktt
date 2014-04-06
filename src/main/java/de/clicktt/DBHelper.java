package de.clicktt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DBHelper {

	public static void createTables(){
		Connection result = null;
		try {
			InitialContext ic = new InitialContext();
			Context initialContext = (Context) ic.lookup("java:comp/env");
			DataSource datasource = (DataSource) initialContext
					.lookup("jdbc/PostgreSQLDS");
			result = datasource.getConnection();
			String query = "CREATE TABLE Spiele("
					+ "Liga INTEGER NOT NULL,"
					+ "Datum VARCHAR(255),"
					+ "Halle INTEGER,"
					+ "Nummer INTEGER,"
					+ "Heim VARCHAR(255),"
					+ "Gast VARCHAR(255),"
					+ "Punkteheim INTEGER,"
					+ "Punktegast INTEGER)";
			Statement stmt = result.createStatement();
			stmt.execute(query);
			stmt.close();
			result.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}
	public static void insertGame(int liga, String datum, int halle,
			int spielnr, String heim, String gast, int heimpunkte,
			int gastpunkte) {
		Connection result = null;
		try {
			InitialContext ic = new InitialContext();
			Context initialContext = (Context) ic.lookup("java:comp/env");
			DataSource datasource = (DataSource) initialContext
					.lookup("jdbc/PostgreSQLDS");
			result = datasource.getConnection();
			String query = "INSERT INTO Spiele (Liga,Datum,Halle,Nummer,Heim,Gast,Punkteheim,Punktegast) VALUES (?,?,?,?,?,?,?,?)";
			PreparedStatement pstmt = result.prepareStatement(query);
			pstmt.setInt(1, liga);
			pstmt.setString(2, datum);
			pstmt.setInt(3, halle);
			pstmt.setInt(4, spielnr);
			pstmt.setString(5, heim);
			pstmt.setString(6, gast);
			pstmt.setInt(7, heimpunkte);
			pstmt.setInt(8, gastpunkte);
			pstmt.executeUpdate();
			result.commit();
			pstmt.close();
			result.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public static String getSpieleliste(int liga) {
		String retval = "";
		Connection result = null;
		try {

			InitialContext ic = new InitialContext();
			Context initialContext = (Context) ic.lookup("java:comp/env");
			DataSource datasource = (DataSource) initialContext
					.lookup("jdbc/PostgreSQLDS");
			result = datasource.getConnection();
			String query = "SELECT * FROM Spiele WHERE Liga=?";
			PreparedStatement pstmt = result.prepareStatement(query);
			pstmt.setInt(1, liga);
			ResultSet rs = pstmt.executeQuery();
			while(rs.next()){
				retval += rs.getString("Heim")+ "-"+rs.getString("Gast") + "\n"; 
			}
			rs.close();
			pstmt.close();
			result.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return retval;
	}
}
