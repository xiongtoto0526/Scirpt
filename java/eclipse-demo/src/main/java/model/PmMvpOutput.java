package model;

import java.io.Serializable;
import javax.persistence.*;


/**
 * The persistent class for the pm_mvp_output database table.
 * 
 */
@Entity
@Table(name="pm_mvp_output")
@NamedQuery(name="PmMvpOutput.findAll", query="SELECT p FROM PmMvpOutput p")
public class PmMvpOutput implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long id;

	@Column(name="content_url")
	private String contentUrl;

	private String descr;

	private String name;

	@Column(name="preview_url")
	private String previewUrl;

	private String type;

	//bi-directional many-to-one association to PmMvp
	@ManyToOne
	@JoinColumn(name="pm_mvp_id")
	private PmMvp pmMvp;

	public PmMvpOutput() {
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getContentUrl() {
		return this.contentUrl;
	}

	public void setContentUrl(String contentUrl) {
		this.contentUrl = contentUrl;
	}

	public String getDescr() {
		return this.descr;
	}

	public void setDescr(String descr) {
		this.descr = descr;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPreviewUrl() {
		return this.previewUrl;
	}

	public void setPreviewUrl(String previewUrl) {
		this.previewUrl = previewUrl;
	}

	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public PmMvp getPmMvp() {
		return this.pmMvp;
	}

	public void setPmMvp(PmMvp pmMvp) {
		this.pmMvp = pmMvp;
	}

}