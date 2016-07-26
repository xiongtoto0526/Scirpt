package model;

import java.io.Serializable;
import javax.persistence.*;
import java.util.List;


/**
 * The persistent class for the pm_template_detail database table.
 * 
 */
@Entity
@Table(name="pm_template_detail")
@NamedQuery(name="PmTemplateDetail.findAll", query="SELECT p FROM PmTemplateDetail p")
public class PmTemplateDetail implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	private String name;

	private int seq;

	//bi-directional many-to-one association to PmTemplate
	@ManyToOne
	@JoinColumn(name="pm_template_id")
	private PmTemplate pmTemplate;

	//bi-directional many-to-one association to PmTemplateDetail
	@ManyToOne
	@JoinColumn(name="parent_template_id")
	private PmTemplateDetail pmTemplateDetail;

	//bi-directional many-to-one association to PmTemplateDetail
	@OneToMany(mappedBy="pmTemplateDetail")
	private List<PmTemplateDetail> pmTemplateDetails;

	public PmTemplateDetail() {
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getSeq() {
		return this.seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public PmTemplate getPmTemplate() {
		return this.pmTemplate;
	}

	public void setPmTemplate(PmTemplate pmTemplate) {
		this.pmTemplate = pmTemplate;
	}

	public PmTemplateDetail getPmTemplateDetail() {
		return this.pmTemplateDetail;
	}

	public void setPmTemplateDetail(PmTemplateDetail pmTemplateDetail) {
		this.pmTemplateDetail = pmTemplateDetail;
	}

	public List<PmTemplateDetail> getPmTemplateDetails() {
		return this.pmTemplateDetails;
	}

	public void setPmTemplateDetails(List<PmTemplateDetail> pmTemplateDetails) {
		this.pmTemplateDetails = pmTemplateDetails;
	}

	public PmTemplateDetail addPmTemplateDetail(PmTemplateDetail pmTemplateDetail) {
		getPmTemplateDetails().add(pmTemplateDetail);
		pmTemplateDetail.setPmTemplateDetail(this);

		return pmTemplateDetail;
	}

	public PmTemplateDetail removePmTemplateDetail(PmTemplateDetail pmTemplateDetail) {
		getPmTemplateDetails().remove(pmTemplateDetail);
		pmTemplateDetail.setPmTemplateDetail(null);

		return pmTemplateDetail;
	}

}