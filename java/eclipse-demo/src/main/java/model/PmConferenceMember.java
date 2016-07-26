package model;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigInteger;


/**
 * The persistent class for the pm_conference_member database table.
 * 
 */
@Entity
@Table(name="pm_conference_member")
@NamedQuery(name="PmConferenceMember.findAll", query="SELECT p FROM PmConferenceMember p")
public class PmConferenceMember implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	@Column(name="user_id")
	private BigInteger userId;

	@Column(name="user_name")
	private String userName;

	//bi-directional many-to-one association to PmProject
	@ManyToOne
	@JoinColumn(name="pm_project_id")
	private PmProject pmProject;

	public PmConferenceMember() {
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public BigInteger getUserId() {
		return this.userId;
	}

	public void setUserId(BigInteger userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public PmProject getPmProject() {
		return this.pmProject;
	}

	public void setPmProject(PmProject pmProject) {
		this.pmProject = pmProject;
	}

}