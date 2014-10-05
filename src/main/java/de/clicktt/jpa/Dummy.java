package de.clicktt.jpa;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Dummy {
	@Id
	private long id;
	
	private String text;
	
	public Dummy(){}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
	
	
}
