package model;

import java.io.Serializable;
import javax.persistence.*;
import java.util.List;


/**
 * The persistent class for the pm_template database table.
 * 
 */
@Entity
@Table(name="pm_template")
@NamedQuery(name="PmTemplate.findAll", query="SELECT p FROM PmTemplate p")
public class PmTemplate implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	@Column(name="is_default")
	private byte isDefault;

	private String name;

	private String type;

	//bi-directional many-to-one association to PmProject
	@OneToMany(mappedBy="pmTemplate")
	private List<PmProject> pmProjects;

	//bi-directional many-to-one association to PmTemplateDetail
	@OneToMany(mappedBy="pmTemplate")
	private List<PmTemplateDetail> pmTemplateDetails;

	public PmTemplate() {
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public byte getIsDefault() {
		return this.isDefault;
	}

	public void setIsDefault(byte isDefault) {
		this.isDefault = isDefault;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public List<PmProject> getPmProjects() {
		return this.pmProjects;
	}

	public void setPmProjects(List<PmProject> pmProjects) {
		this.pmProjects = pmProjects;
	}

	public PmProject addPmProject(PmProject pmProject) {
		getPmProjects().add(pmProject);
		pmProject.setPmTemplate(this);

		return pmProject;
	}

	public PmProject removePmProject(PmProject pmProject) {
		getPmProjects().remove(pmProject);
		pmProject.setPmTemplate(null);

		return pmProject;
	}

	public List<PmTemplateDetail> getPmTemplateDetails() {
		return this.pmTemplateDetails;
	}

	public void setPmTemplateDetails(List<PmTemplateDetail> pmTemplateDetails) {
		this.pmTemplateDetails = pmTemplateDetails;
	}

	public PmTemplateDetail addPmTemplateDetail(PmTemplateDetail pmTemplateDetail) {
		getPmTemplateDetails().add(pmTemplateDetail);
		pmTemplateDetail.setPmTemplate(this);

		return pmTemplateDetail;
	}

	public PmTemplateDetail removePmTemplateDetail(PmTemplateDetail pmTemplateDetail) {
		getPmTemplateDetails().remove(pmTemplateDetail);
		pmTemplateDetail.setPmTemplate(null);

		return pmTemplateDetail;
	}

}