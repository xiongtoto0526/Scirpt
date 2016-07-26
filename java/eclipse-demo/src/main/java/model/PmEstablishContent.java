package model;

import java.io.Serializable;
import javax.persistence.*;


/**
 * The persistent class for the pm_establish_content database table.
 * 
 */
@Entity
@Table(name="pm_establish_content")
@NamedQuery(name="PmEstablishContent.findAll", query="SELECT p FROM PmEstablishContent p")
public class PmEstablishContent implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	private String category;

	private String content;

	private int seq;

	private String title;

	//bi-directional many-to-one association to PmProject
	@ManyToOne
	@JoinColumn(name="pm_project_id")
	private PmProject pmProject;

	public PmEstablishContent() {
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getCategory() {
		return this.category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getContent() {
		return this.content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public int getSeq() {
		return this.seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public String getTitle() {
		return this.title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public PmProject getPmProject() {
		return this.pmProject;
	}

	public void setPmProject(PmProject pmProject) {
		this.pmProject = pmProject;
	}

}