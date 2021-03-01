package com.flutterapp.resource.dto;

import com.flutterapp.domain.Image;

import java.io.Serializable;

public class ImageDTO implements Serializable {

    private Long id;
    private String imageName;
    private String imageUrl;
    private Long userId;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getImageName() {
        return imageName;
    }

    public void setImageName(String imageName) {
        this.imageName = imageName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public static ImageDTO toImageDTO(Image image){
        ImageDTO imageDTO = new ImageDTO();

        imageDTO.setId(image.getId());
        imageDTO.setUserId(image.getCreatedBy());
        imageDTO.setImageUrl(""+ image.getImageUID());
        imageDTO.setImageName(image.getName());

        return imageDTO;
    }

}
