package com.example.nexa.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.Objects;
import java.util.Set;

import static org.springframework.data.jpa.domain.AbstractPersistable_.id;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@IdClass(InteriorImageKey.class)
public class InteriorImage {
    @Id
    private String email;

    @Id
    private int interiorImageId;
    private String augmentedImageUrl;
    private String texture;
    private String complexityScore;
    private String TimeStamp;
    private String interiorImageUrl;

    //color-related fields
    private String wallColorKMeans;
    private String wallColorHistogram;
    private String wallColorMedian;
    private String wallSampledColor1;
    private String wallSampledColor2;

    private String floorColorKMeans;
    private String floorColorHistogram;
    private String floorColorMedian;
    private String floorSampledColor1;
    private String floorSampledColor2;

    private String ceilingColorKMeans;
    private String ceilingColorHistogram;
    private String ceilingColorMedian;
    private String ceilingSampledColor1;
    private String ceilingSampledColor2;

    private String nonWallAreaColorKMeans;
    private String nonWallAreaColorHistogram;
    private String nonWallAreaColorMedian;
    private String nonWallAreaSampledColor1;
    private String nonWallAreaSampledColor2;

    private String doorColorKMeans;
    private String doorColorHistogram;
    private String doorColorMedian;
    private String doorSampledColor1;
    private String doorSampledColor2;

    private String tableColorKMeans;
    private String tableColorHistogram;
    private String tableColorMedian;
    private String tableSampledColor1;
    private String tableSampledColor2;

    private String curtainColorKMeans;
    private String curtainColorHistogram;
    private String curtainColorMedian;
    private String curtainSampledColor1;
    private String curtainSampledColor2;

    private String chairColorKMeans;
    private String chairColorHistogram;
    private String chairColorMedian;
    private String chairSampledColor1;
    private String chairSampledColor2;

    private String sofaColorKMeans;
    private String sofaColorHistogram;
    private String sofaColorMedian;
    private String sofaSampledColor1;
    private String sofaSampledColor2;

    private String screenColorKMeans;
    private String screenColorHistogram;
    private String screenColorMedian;
    private String screenSampledColor1;
    private String screenSampledColor2;

    private String swivelColorKMeans;
    private String swivelColorHistogram;
    private String swivelColorMedian;
    private String swivelSampledColor1;
    private String swivelSampledColor2;



//    //not
//    @Transient // This indicates that this field is not persisted in the database, but rather is a part of the query result
//    @JsonProperty("colorCode") // Ensures the field is included in the JSON output
//    private String colorCode;


    @ManyToOne
    @JoinColumn(name = "email", insertable = false, updatable = false)
    @JsonBackReference
    private Client client;

    @OneToMany(mappedBy = "interiorImage", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Generate> generates;

    public InteriorImage(String email, int interiorImageId) {
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        InteriorImage that = (InteriorImage) o;
        return Objects.equals(email, that.email) &&
                Objects.equals(interiorImageId, that.interiorImageId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(email, interiorImageId);
    }
    public String getInteriorImageUrl() {
        return interiorImageUrl;
    }

    public String getEmail() {
        return this.email;
    }

    public InteriorImage(String email, int interiorImageId, String augmentedImageUrl, String texture, String complexityScore, String timeStamp, String interiorImageUrl) {
        this.email = email;
        this.interiorImageId = interiorImageId;
        this.augmentedImageUrl = augmentedImageUrl;
        this.texture = texture;
        this.complexityScore = complexityScore;
        TimeStamp = timeStamp;
        this.interiorImageUrl = interiorImageUrl;
    }

    public void setTexture(String texture) {
        this.texture =texture;
    }

    public void setWallColorKMeans(String wallColorKMeans) {
        this.wallColorKMeans = wallColorKMeans;
    }

    public void setWallColorHistogram(String wallColorHistogram) {
        this.wallColorHistogram =wallColorHistogram;
    }

    public void setWallColorMedian(String wallColorMedian) {
        this.wallColorMedian = wallColorMedian;
    }

    public void setWallSampledColor1(String string) {
        this.wallSampledColor1 =string;
    }

    public void setWallSampledColor2(String string) {
        this.wallSampledColor2=string;
    }

    public void setFloorColorKMeans(String colorKMeans) {
        this.floorColorKMeans =colorKMeans;
    }
    public void setFloorColorHistogram(String wallColorHistogram) {
        this.floorColorHistogram =wallColorHistogram;
    }

    public void setFloorColorMedian(String wallColorMedian) {
        this.floorColorMedian = wallColorMedian;
    }

    public void setFloorSampledColor1(String string) {
        this.floorSampledColor1 =string;
    }

    public void setFloorSampledColor2(String string) {
        this.floorSampledColor2=string;
    }
    public void setCeilingColorKMeans(String colorKMeans) {
        this.ceilingColorKMeans =colorKMeans;
    }
    public void setCeilingColorHistogram(String wallColorHistogram) {
        this.ceilingColorHistogram =wallColorHistogram;
    }

    public void setCeilingColorMedian(String wallColorMedian) {
        this.ceilingColorMedian = wallColorMedian;
    }

    public void setCeilingSampledColor1(String string) {
        this.ceilingSampledColor1 =string;
    }

    public void setCeilingSampledColor2(String string) {
        this.ceilingSampledColor2=string;
    }


    public void setNonWallAreaColorKMeans(String colorKMeans) {
        this.nonWallAreaColorKMeans =colorKMeans;
    }
    public void setNonWallAreaColorHistogram(String ColorHistogram) {
        this.nonWallAreaColorHistogram =ColorHistogram;
    }

    public void setNonWallAreaColorMedian(String ColorMedian) {
        this.nonWallAreaColorMedian = ColorMedian;
    }

    public void setNonWallAreaSampledColor1(String string) {
        this.nonWallAreaSampledColor1 =string;
    }

    public void setNonWallAreaSampledColor2(String string) {
        this.nonWallAreaSampledColor2=string;
    }


    public void setDoorColorKMeans(String colorKMeans) {
        this.doorColorKMeans =colorKMeans;
    }
    public void setDoorColorHistogram(String ColorHistogram) {
        this.doorColorHistogram =ColorHistogram;
    }

    public void setDoorColorMedian(String ColorMedian) {
        this.doorColorMedian = ColorMedian;
    }

    public void setDoorSampledColor1(String string) {
        this.doorSampledColor1 =string;
    }

    public void setDoorSampledColor2(String string) {
        this.doorSampledColor2=string;
    }

    public void setTableColorKMeans(String colorKMeans) {
        this.tableColorKMeans =colorKMeans;
    }
    public void setTableColorHistogram(String ColorHistogram) {
        this.tableColorHistogram =ColorHistogram;
    }

    public void setTableColorMedian(String ColorMedian) {
        this.tableColorMedian = ColorMedian;
    }

    public void setTableSampledColor1(String string) {
        this.tableSampledColor1 =string;
    }

    public void setTableSampledColor2(String string) {
        this.tableSampledColor2=string;
    }

    public void setCurtainColorKMeans(String colorKMeans) {
        this.curtainColorKMeans =colorKMeans;
    }
    public void setCurtainColorHistogram(String ColorHistogram) {
        this.curtainColorHistogram =ColorHistogram;
    }

    public void setCurtainColorMedian(String ColorMedian) {
        this.curtainColorMedian = ColorMedian;
    }

    public void setCurtainSampledColor1(String string) {
        this.curtainSampledColor1 =string;
    }

    public void setCurtainSampledColor2(String string) {
        this.curtainSampledColor2=string;
    }

    public void setChairColorKMeans(String colorKMeans) {
        this.chairColorKMeans =colorKMeans;
    }
    public void setChairColorHistogram(String ColorHistogram) {
        this.chairColorHistogram =ColorHistogram;
    }

    public void setChairColorMedian(String ColorMedian) {
        this.chairColorMedian = ColorMedian;
    }

    public void setChairSampledColor1(String string) {
        this.chairSampledColor1 =string;
    }

    public void setChairSampledColor2(String string) {
        this.chairSampledColor2=string;
    }

    public void setSofaColorKMeans(String colorKMeans) {
        this.sofaColorKMeans =colorKMeans;
    }
    public void setSofaColorHistogram(String ColorHistogram) {
        this.sofaColorHistogram =ColorHistogram;
    }

    public void setSofaColorMedian(String ColorMedian) {
        this.sofaColorMedian = ColorMedian;
    }

    public void setSofaSampledColor1(String string) {
        this.sofaSampledColor1 =string;
    }

    public void setSofaSampledColor2(String string) {
        this.sofaSampledColor2=string;
    }

    public void setScreenColorKMeans(String colorKMeans) {
        this.screenColorKMeans =colorKMeans;
    }
    public void setScreenColorHistogram(String ColorHistogram) {
        this.screenColorHistogram =ColorHistogram;
    }

    public void setScreenColorMedian(String ColorMedian) {
        this.screenColorMedian = ColorMedian;
    }

    public void setScreenSampledColor1(String string) {
        this.screenSampledColor1 =string;
    }

    public void setScreenSampledColor2(String string) {
        this.screenSampledColor2=string;
    }

    public void setSwivelColorKMeans(String colorKMeans) {
        this.swivelColorKMeans =colorKMeans;
    }
    public void setSwivelColorHistogram(String ColorHistogram) {
        this.swivelColorHistogram =ColorHistogram;
    }

    public void setSwivelColorMedian(String ColorMedian) {
        this.swivelColorMedian = ColorMedian;
    }

    public void setSwivelSampledColor1(String string) {
        this.swivelSampledColor1 =string;
    }

    public void setSwivelSampledColor2(String string) {
        this.swivelSampledColor2=string;
    }

    public void setEmail(String email) {
        this.email=email;
    }

    public void setInteriorImageUrl(String imageUrl) {
        this.interiorImageUrl=imageUrl;
    }

    public void setTimeStamp(String string) {
        this.TimeStamp=string;
    }


    public int getInteriorImageId() {
        return this.interiorImageId;
    }
}
