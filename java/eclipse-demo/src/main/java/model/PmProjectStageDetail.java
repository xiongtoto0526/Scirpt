package model;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;


/**
 * The persistent class for the pm_project_stage_detail database table.
 * 
 */
@Entity
@Table(name="pm_project_stage_detail")
@NamedQuery(name="PmProjectStageDetail.findAll", query="SELECT p FROM PmProjectStageDetail p")
public class PmProjectStageDetail implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	private String advantage;

	private BigDecimal buget;

	private BigDecimal cost;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="end_time")
	private Date endTime;

	private String goal;

	private String name;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="plan_end_time")
	private Date planEndTime;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="plan_start_time")
	private Date planStartTime;

	private String priority;

	private String question;

	private int seq;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="start_time")
	private Date startTime;

	private String weakness;

	//bi-directional many-to-one association to PmMvp
	@OneToMany(mappedBy="pmProjectStageDetail")
	private List<PmMvp> pmMvps;

	//bi-directional many-to-one association to PmProject
	@ManyToOne
	@JoinColumn(name="pm_project_id")
	private PmProject pmProject;

	public PmProjectStageDetail() {
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getAdvantage() {
		return this.advantage;
	}

	public void setAdvantage(String advantage) {
		this.advantage = advantage;
	}

	public BigDecimal getBuget() {
		return this.buget;
	}

	public void setBuget(BigDecimal buget) {
		this.buget = buget;
	}

	public BigDecimal getCost() {
		return this.cost;
	}

	public void setCost(BigDecimal cost) {
		this.cost = cost;
	}

	public Date getEndTime() {
		return this.endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public String getGoal() {
		return this.goal;
	}

	public void setGoal(String goal) {
		this.goal = goal;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getPlanEndTime() {
		return this.planEndTime;
	}

	public void setPlanEndTime(Date planEndTime) {
		this.planEndTime = planEndTime;
	}

	public Date getPlanStartTime() {
		return this.planStartTime;
	}

	public void setPlanStartTime(Date planStartTime) {
		this.planStartTime = planStartTime;
	}

	public String getPriority() {
		return this.priority;
	}

	public void setPriority(String priority) {
		this.priority = priority;
	}

	public String getQuestion() {
		return this.question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public int getSeq() {
		return this.seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public Date getStartTime() {
		return this.startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public String getWeakness() {
		return this.weakness;
	}

	public void setWeakness(String weakness) {
		this.weakness = weakness;
	}

	public List<PmMvp> getPmMvps() {
		return this.pmMvps;
	}

	public void setPmMvps(List<PmMvp> pmMvps) {
		this.pmMvps = pmMvps;
	}

	public PmMvp addPmMvp(PmMvp pmMvp) {
		getPmMvps().add(pmMvp);
		pmMvp.setPmProjectStageDetail(this);

		return pmMvp;
	}

	public PmMvp removePmMvp(PmMvp pmMvp) {
		getPmMvps().remove(pmMvp);
		pmMvp.setPmProjectStageDetail(null);

		return pmMvp;
	}

	public PmProject getPmProject() {
		return this.pmProject;
	}

	public void setPmProject(PmProject pmProject) {
		this.pmProject = pmProject;
	}

}