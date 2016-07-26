package model;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;
import java.math.BigInteger;
import java.util.List;


/**
 * The persistent class for the pm_project database table.
 * 
 */
@Entity
@Table(name="pm_project")
@NamedQuery(name="PmProject.findAll", query="SELECT p FROM PmProject p")
public class PmProject implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="create_time")
	private Date createTime;

	@Column(name="current_stage_id")
	private BigInteger currentStageId;

	private String descr;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="establish_time")
	private Date establishTime;

	@Column(name="logo_url")
	private String logoUrl;

	private String name;

	@Column(name="producer_id")
	private BigInteger producerId;

	@Column(name="producer_name")
	private String producerName;

	private String status;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="update_time")
	private Date updateTime;

	//bi-directional many-to-one association to PmComment
	@OneToMany(mappedBy="pmProject")
	private List<PmComment> pmComments;

	//bi-directional many-to-one association to PmConference
	@OneToMany(mappedBy="pmProject")
	private List<PmConference> pmConferences;

	//bi-directional many-to-one association to PmConferenceMember
	@OneToMany(mappedBy="pmProject")
	private List<PmConferenceMember> pmConferenceMembers;

	//bi-directional many-to-one association to PmEstablishContent
	@OneToMany(mappedBy="pmProject")
	private List<PmEstablishContent> pmEstablishContents;

	//bi-directional many-to-one association to PmMilestone
	@OneToMany(mappedBy="pmProject")
	private List<PmMilestone> pmMilestones;

	//bi-directional many-to-one association to PmTemplate
	@ManyToOne
	@JoinColumn(name="pm_template_id")
	private PmTemplate pmTemplate;

	//bi-directional many-to-one association to PmProjectStageDetail
	@OneToMany(mappedBy="pmProject")
	private List<PmProjectStageDetail> pmProjectStageDetails;

	public PmProject() {
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public BigInteger getCurrentStageId() {
		return this.currentStageId;
	}

	public void setCurrentStageId(BigInteger currentStageId) {
		this.currentStageId = currentStageId;
	}

	public String getDescr() {
		return this.descr;
	}

	public void setDescr(String descr) {
		this.descr = descr;
	}

	public Date getEstablishTime() {
		return this.establishTime;
	}

	public void setEstablishTime(Date establishTime) {
		this.establishTime = establishTime;
	}

	public String getLogoUrl() {
		return this.logoUrl;
	}

	public void setLogoUrl(String logoUrl) {
		this.logoUrl = logoUrl;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public BigInteger getProducerId() {
		return this.producerId;
	}

	public void setProducerId(BigInteger producerId) {
		this.producerId = producerId;
	}

	public String getProducerName() {
		return this.producerName;
	}

	public void setProducerName(String producerName) {
		this.producerName = producerName;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getUpdateTime() {
		return this.updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public List<PmComment> getPmComments() {
		return this.pmComments;
	}

	public void setPmComments(List<PmComment> pmComments) {
		this.pmComments = pmComments;
	}

	public PmComment addPmComment(PmComment pmComment) {
		getPmComments().add(pmComment);
		pmComment.setPmProject(this);

		return pmComment;
	}

	public PmComment removePmComment(PmComment pmComment) {
		getPmComments().remove(pmComment);
		pmComment.setPmProject(null);

		return pmComment;
	}

	public List<PmConference> getPmConferences() {
		return this.pmConferences;
	}

	public void setPmConferences(List<PmConference> pmConferences) {
		this.pmConferences = pmConferences;
	}

	public PmConference addPmConference(PmConference pmConference) {
		getPmConferences().add(pmConference);
		pmConference.setPmProject(this);

		return pmConference;
	}

	public PmConference removePmConference(PmConference pmConference) {
		getPmConferences().remove(pmConference);
		pmConference.setPmProject(null);

		return pmConference;
	}

	public List<PmConferenceMember> getPmConferenceMembers() {
		return this.pmConferenceMembers;
	}

	public void setPmConferenceMembers(List<PmConferenceMember> pmConferenceMembers) {
		this.pmConferenceMembers = pmConferenceMembers;
	}

	public PmConferenceMember addPmConferenceMember(PmConferenceMember pmConferenceMember) {
		getPmConferenceMembers().add(pmConferenceMember);
		pmConferenceMember.setPmProject(this);

		return pmConferenceMember;
	}

	public PmConferenceMember removePmConferenceMember(PmConferenceMember pmConferenceMember) {
		getPmConferenceMembers().remove(pmConferenceMember);
		pmConferenceMember.setPmProject(null);

		return pmConferenceMember;
	}

	public List<PmEstablishContent> getPmEstablishContents() {
		return this.pmEstablishContents;
	}

	public void setPmEstablishContents(List<PmEstablishContent> pmEstablishContents) {
		this.pmEstablishContents = pmEstablishContents;
	}

	public PmEstablishContent addPmEstablishContent(PmEstablishContent pmEstablishContent) {
		getPmEstablishContents().add(pmEstablishContent);
		pmEstablishContent.setPmProject(this);

		return pmEstablishContent;
	}

	public PmEstablishContent removePmEstablishContent(PmEstablishContent pmEstablishContent) {
		getPmEstablishContents().remove(pmEstablishContent);
		pmEstablishContent.setPmProject(null);

		return pmEstablishContent;
	}

	public List<PmMilestone> getPmMilestones() {
		return this.pmMilestones;
	}

	public void setPmMilestones(List<PmMilestone> pmMilestones) {
		this.pmMilestones = pmMilestones;
	}

	public PmMilestone addPmMilestone(PmMilestone pmMilestone) {
		getPmMilestones().add(pmMilestone);
		pmMilestone.setPmProject(this);

		return pmMilestone;
	}

	public PmMilestone removePmMilestone(PmMilestone pmMilestone) {
		getPmMilestones().remove(pmMilestone);
		pmMilestone.setPmProject(null);

		return pmMilestone;
	}

	public PmTemplate getPmTemplate() {
		return this.pmTemplate;
	}

	public void setPmTemplate(PmTemplate pmTemplate) {
		this.pmTemplate = pmTemplate;
	}

	public List<PmProjectStageDetail> getPmProjectStageDetails() {
		return this.pmProjectStageDetails;
	}

	public void setPmProjectStageDetails(List<PmProjectStageDetail> pmProjectStageDetails) {
		this.pmProjectStageDetails = pmProjectStageDetails;
	}

	public PmProjectStageDetail addPmProjectStageDetail(PmProjectStageDetail pmProjectStageDetail) {
		getPmProjectStageDetails().add(pmProjectStageDetail);
		pmProjectStageDetail.setPmProject(this);

		return pmProjectStageDetail;
	}

	public PmProjectStageDetail removePmProjectStageDetail(PmProjectStageDetail pmProjectStageDetail) {
		getPmProjectStageDetails().remove(pmProjectStageDetail);
		pmProjectStageDetail.setPmProject(null);

		return pmProjectStageDetail;
	}

}