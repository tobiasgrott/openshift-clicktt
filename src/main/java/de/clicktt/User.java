package de.clicktt;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Persistence;
import javax.persistence.Query;
import javax.persistence.Version;

@Entity
public class User {
	@Id @GeneratedValue(strategy = GenerationType.AUTO)
	private int id;
	
	@Column(nullable = false, length=200)
	private String gcmRegId;
	
	@Column(length = 200)
	private String name;
	
	@Column(length = 200)
	private String email;
	
	@Version
	private Timestamp lastupdate;
	public User(){}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getGcmRegId() {
		return gcmRegId;
	}
	public void setGcmRegId(String gcmRegId) {
		this.gcmRegId = gcmRegId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Timestamp getLastupdate() {
		return lastupdate;
	}
	public void setLastupdate(Timestamp lastupdate) {
		this.lastupdate = lastupdate;
	}
	public void store(){
		Download dl = new Download();
		dl.createEntity(this);
	}
	public static User getByMail(String mail){
		User retval = null;
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("JPAUnit");
		EntityManager em = emf.createEntityManager();
		try{
			Query query = em.createQuery("SELECT u from User where u.email=:email");
			query.setParameter("email", mail);
			retval = (User) query.getSingleResult();
		}finally{
			em.close();
		}
		return retval;
	}
	public static boolean isUserExisted(String mail){
		User u = getByMail(mail);
		if(u == null){
			return false;
		}else{
			return true;
		}
	}
	public static List<User> getAllUsers(){
		List<User> retval = new ArrayList<User>();
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("JPAUnit");;
		EntityManager em = emf.createEntityManager();
		try{
			Query query = em.createQuery("SELECT u from User");
			retval = (List<User>) query.getResultList();
		}finally{
			em.close();
		}
		return retval;
	}
}
