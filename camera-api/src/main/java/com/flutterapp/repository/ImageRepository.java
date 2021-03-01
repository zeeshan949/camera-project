package com.flutterapp.repository;

import com.flutterapp.domain.Image;
import com.flutterapp.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ImageRepository extends JpaRepository<Image, Long> {
    public Optional<List<Image>> getAllByCreatedByEqualsAndDeletionStatus(Long userId, boolean deletionStatus);

    public Optional<Image> getFirstByImageUIDAndDeletionStatus(String uuid, boolean deletionStatus);
}
