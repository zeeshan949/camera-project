package com.flutterapp.resource;

import com.flutterapp.domain.Image;
import com.flutterapp.resource.dto.ImageDTO;
import com.flutterapp.service.ImageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api")
public class ImageController {

    private static final Logger logger = LoggerFactory.getLogger(ImageController.class);

    private ImageService imageService;

    public ImageController(ImageService imageService) {
        this.imageService = imageService;
    }

    @GetMapping(value = "/image/{uuid}", produces = MediaType.IMAGE_JPEG_VALUE)
    public @ResponseBody byte[] getFile(@PathVariable String uuid) {
        logger.info("Request to load Image from DB for UUID {}", uuid);

        return imageService.getImageContent(uuid);
    }

    @GetMapping(value = "user/{userId}/images")
    public ResponseEntity<List<ImageDTO>> getAllImages(@PathVariable Long userId) {
        logger.info("Request to load all user {} Images", userId);
        List<ImageDTO> imageList = imageService.getAllUserImages(userId);
        if (imageList.isEmpty()){
            logger.info("No image found for user {}", userId);
            return ResponseEntity.noContent().build();
        }else {
            logger.info("{} images found for user {}", imageList.size(), userId);
            return ResponseEntity.ok(imageList);
        }

    }

    @PostMapping(value = "user/{userId}/upload")
    public ResponseEntity<String> singleFileUpload(@PathVariable Long userId, @RequestParam("file") MultipartFile file) {
        try {
            logger.info("Upload image for the user {} ", userId);

            Image image = new Image();

            image.setName(file.getOriginalFilename());
            image.setImageUID(UUID.randomUUID().toString());

            // Get the file and save it somewhere
            byte[] bytes = file.getBytes();
            image.setImage(bytes);

            image.setCreatedBy(userId);
            image.setModifiedBy(userId);
            image.setCreateDate(ZonedDateTime.now());
            image.setModifiedDate(ZonedDateTime.now());
            image.setDeletionStatus(false);

            imageService.saveImage(image);

            logger.info("Saved file {} with UUID {} for the user {} ", image.getName(), image.getImageUID(), image.getCreatedBy());

        } catch (IOException e) {
            e.printStackTrace();
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        return ResponseEntity.ok("success");
    }

}
