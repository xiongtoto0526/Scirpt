package model;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;
import java.util.List;


/**
 * The persistent class for the pm_comment database table.
 * 
 */
@Entity
@Table(name="pm_comment")
@NamedQuery(name="PmComment.findAll", query="SELECT p FROM PmComment p")
public class PmComment implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	private String category;

	private String content;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="create_time")
	private Date createTime;

	@Column(name="receiver_name")
	private String receiverName;

	@Column(name="sender_name")
	private String senderName;

	//bi-directional many-to-one association to PmProject
	@ManyToOne
	@JoinColumn(name="pm_project_id")
	private PmProject pmProject;

	//bi-directional many-to-one association to PmCommentReply
	@OneToMany(mappedBy="pmComment")
	private List<PmCommentReply> pmCommentReplies;

	public PmComment() {
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

	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getReceiverName() {
		return this.receiverName;
	}

	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}

	public String getSenderName() {
		return this.senderName;
	}

	public void setSenderName(String senderName) {
		this.senderName = senderName;
	}

	public PmProject getPmProject() {
		return this.pmProject;
	}

	public void setPmProject(PmProject pmProject) {
		this.pmProject = pmProject;
	}

	public List<PmCommentReply> getPmCommentReplies() {
		return this.pmCommentReplies;
	}

	public void setPmCommentReplies(List<PmCommentReply> pmCommentReplies) {
		this.pmCommentReplies = pmCommentReplies;
	}

	public PmCommentReply addPmCommentReply(PmCommentReply pmCommentReply) {
		getPmCommentReplies().add(pmCommentReply);
		pmCommentReply.setPmComment(this);

		return pmCommentReply;
	}

	public PmCommentReply removePmCommentReply(PmCommentReply pmCommentReply) {
		getPmCommentReplies().remove(pmCommentReply);
		pmCommentReply.setPmComment(null);

		return pmCommentReply;
	}

}