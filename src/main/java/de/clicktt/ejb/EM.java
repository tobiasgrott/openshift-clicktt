package de.clicktt.ejb;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class EM {
	private static EntityManager em;
	private static EntityManagerFactory emf;
	public static EntityManager getEm(){
		if(em == null){
			emf = Persistence.createEntityManagerFactory("JPAUnit");
			em = emf.createEntityManager();
		}
		return em;
	}
}
