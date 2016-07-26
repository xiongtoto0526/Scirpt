package model;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;


/**
 * The persistent class for the pm_conference database table.
 * 
 */
@Entity
@Table(name="pm_conference")
@NamedQuery(name="PmConference.findAll", query="SELECT p FROM PmConference p")
public class PmConference implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	private String content;

	private String name;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="start_time")
	private Date startTime;

	//bi-directional many-to-one association to PmProject
	@ManyToOne
	@JoinColumn(name="pm_project_id")
	private PmProject pmProject;

	public PmConference() {
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getContent() {
		return this.content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getStartTime() {
		return this.startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public PmProject getPmProject() {
		return this.pmProject;
	}

	public void setPmProject(PmProject pmProject) {
		this.pmProject = pmProject;
	}

}