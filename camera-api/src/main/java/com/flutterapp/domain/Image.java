package com.flutterapp.domain;

import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.sql.Blob;
import java.time.ZonedDateTime;

@Entity
@Table(name = "images")
public class Image implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Size(min = 0, max = 100)
    @Column(length = 100)
    private String name;

    @Size(min = 0, max = 100)
    @Column(length = 100, name = "image_uid")
    private String imageUID;

    @Lob
    @Basic(fetch = FetchType.LAZY)
    private byte[] image;

    @Size(min = 0, max = 100)
    @Column(length = 20, name = "file_type")
    private String fileType;

    @Column(name = "created_date")
    private ZonedDateTime createDate;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "modified_date")
    private ZonedDateTime modifiedDate;

    @Column(name = "modified_by")
    private Long modifiedBy;

    @Column(name = "deletion_status")
    private Boolean deletionStatus;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image = image;
    }

    public ZonedDateTime getCreateDate() {
        return createDate;
    }

    public void setCreateDate(ZonedDateTime createDate) {
        this.createDate = createDate;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }

    public ZonedDateTime getModifiedDate() {
        return modifiedDate;
    }

    public void setModifiedDate(ZonedDateTime modifiedDate) {
        this.modifiedDate = modifiedDate;
    }

    public Long getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(Long modifiedBy) {
        this.modifiedBy = modifiedBy;
    }

    public Boolean getDeletionStatus() {
        return deletionStatus;
    }

    public void setDeletionStatus(Boolean deletionStatus) {
        this.deletionStatus = deletionStatus;
    }

    public String getImageUID() {
        return imageUID;
    }

    public void setImageUID(String imageUID) {
        this.imageUID = imageUID;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }
}
