package de.clicktt.ejb;

import java.util.List;

import de.clicktt.jpa.Dummy;

public class DummyService {
	public static void save(Dummy d){
		EM.getEm().persist(d);
	}
	public static List<Dummy> findAll(){
		return EM.getEm().createQuery("Select d from Dummy d",Dummy.class).getResultList();
	}
}
