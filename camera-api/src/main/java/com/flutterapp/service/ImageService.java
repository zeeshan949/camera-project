package com.flutterapp.service;

import com.flutterapp.domain.Image;
import com.flutterapp.repository.ImageRepository;
import com.flutterapp.resource.dto.ImageDTO;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class ImageService {

    private ImageRepository imageRepository;

    public ImageService(ImageRepository imageRepository){
        this.imageRepository = imageRepository;
    }

    public boolean saveImage(Image image){
        imageRepository.save(image);
        return true;
    }

    public byte[] getImageContent(String uuid){

        Optional<Image> image = imageRepository.getFirstByImageUIDAndDeletionStatus(uuid, false);
        if (image.isPresent()){
            return image.get().getImage();
        }

        return null;
    }

    public List<ImageDTO> getAllUserImages(Long userId){

        Optional<List<Image>> allUserImages = imageRepository.getAllByCreatedByEqualsAndDeletionStatus(userId, false);

        if(allUserImages.isPresent()){
            return allUserImages.get()
                    .stream()
                    .map(ImageDTO::toImageDTO)
                    .collect(Collectors.toList());
        }
        return Collections.emptyList();
    }
}
