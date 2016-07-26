package model;

import java.io.Serializable;
import javax.persistence.*;
import java.util.List;


/**
 * The persistent class for the pm_mvp database table.
 * 
 */
@Entity
@Table(name="pm_mvp")
@NamedQuery(name="PmMvp.findAll", query="SELECT p FROM PmMvp p")
public class PmMvp implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	private String conclude;

	private String descr;

	private String feedback;

	private String name;

	//bi-directional many-to-one association to PmProjectStageDetail
	@ManyToOne
	@JoinColumn(name="pm_project_stage_detail_id")
	private PmProjectStageDetail pmProjectStageDetail;

	//bi-directional many-to-one association to PmMvpOutput
	@OneToMany(mappedBy="pmMvp")
	private List<PmMvpOutput> pmMvpOutputs;

	public PmMvp() {
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getConclude() {
		return this.conclude;
	}

	public void setConclude(String conclude) {
		this.conclude = conclude;
	}

	public String getDescr() {
		return this.descr;
	}

	public void setDescr(String descr) {
		this.descr = descr;
	}

	public String getFeedback() {
		return this.feedback;
	}

	public void setFeedback(String feedback) {
		this.feedback = feedback;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public PmProjectStageDetail getPmProjectStageDetail() {
		return this.pmProjectStageDetail;
	}

	public void setPmProjectStageDetail(PmProjectStageDetail pmProjectStageDetail) {
		this.pmProjectStageDetail = pmProjectStageDetail;
	}

	public List<PmMvpOutput> getPmMvpOutputs() {
		return this.pmMvpOutputs;
	}

	public void setPmMvpOutputs(List<PmMvpOutput> pmMvpOutputs) {
		this.pmMvpOutputs = pmMvpOutputs;
	}

	public PmMvpOutput addPmMvpOutput(PmMvpOutput pmMvpOutput) {
		getPmMvpOutputs().add(pmMvpOutput);
		pmMvpOutput.setPmMvp(this);

		return pmMvpOutput;
	}

	public PmMvpOutput removePmMvpOutput(PmMvpOutput pmMvpOutput) {
		getPmMvpOutputs().remove(pmMvpOutput);
		pmMvpOutput.setPmMvp(null);

		return pmMvpOutput;
	}

}