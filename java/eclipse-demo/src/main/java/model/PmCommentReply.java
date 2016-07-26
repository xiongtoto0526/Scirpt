package model;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;


/**
 * The persistent class for the pm_comment_reply database table.
 * 
 */
@Entity
@Table(name="pm_comment_reply")
@NamedQuery(name="PmCommentReply.findAll", query="SELECT p FROM PmCommentReply p")
public class PmCommentReply implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	private String content;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="create_time")
	private Date createTime;

	@Column(name="receiver_name")
	private String receiverName;

	@Column(name="sender_name")
	private String senderName;

	//bi-directional many-to-one association to PmComment
	@ManyToOne
	@JoinColumn(name="pm_comment_id")
	private PmComment pmComment;

	public PmCommentReply() {
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

	public PmComment getPmComment() {
		return this.pmComment;
	}

	public void setPmComment(PmComment pmComment) {
		this.pmComment = pmComment;
	}

}