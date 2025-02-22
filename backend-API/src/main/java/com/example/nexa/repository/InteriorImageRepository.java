package com.example.nexa.repository;

import com.example.nexa.entity.InteriorImage;
import com.example.nexa.entity.InteriorImageKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Repository
public interface InteriorImageRepository extends JpaRepository<InteriorImage, InteriorImageKey> {
    @Transactional
    void deleteByEmail(String email);

    boolean existsByEmail(String email);

    List<InteriorImage> findByClientEmail(String email);


    @Query(value = "SELECT ii.*, cpcc.color_group " +
            "FROM interior_image ii " +
            "JOIN color_pallet_color_code cpcc ON ii.email = cpcc.email " +
            "WHERE " +
            "(CASE WHEN ?1 = 'all' THEN TRUE ELSE ii.complexity_score = ?1 END OR ?1 IS NULL) " +
            "AND (CASE WHEN ?2 = 'all' THEN TRUE ELSE ii.texture = ?2 END OR ?2 IS NULL) " +
            "AND (CASE WHEN ?3 = 'all' THEN TRUE ELSE cpcc.color_group = ?3 END OR ?3 IS NULL)",
            nativeQuery = true)
    List<InteriorImage> getAllDataByAllValue(String complexity, String texture, String color);

    @Query("SELECT MAX(ii.interiorImageId) FROM InteriorImage ii WHERE ii.email = :email")
    Integer findMaxInteriorImageIdByEmail(@Param("email") String email);

    @Query("SELECT MAX(ii.interiorImageId) FROM InteriorImage ii")
    Integer findMaxInteriorImageId();

}


