package com.example.nexa.controller;

import com.example.nexa.entity.InteriorImage;
import com.example.nexa.entity.InteriorImageKey;
import com.example.nexa.repository.InteriorImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class ColorAndTextureModelController {
    @Autowired
    private InteriorImageRepository interiorImageRepository;

    @PostMapping("/saveTextureAndColors")
    public ResponseEntity<String> saveTextureAndColors(@RequestBody Map<String, Object> data) {
        try {
            // Parse data
            String email = (String) data.get("email");
            int interiorImageId = (int) data.get("interiorImageId");

            // Find the existing interior image or create a new one
            InteriorImageKey key = new InteriorImageKey(email, interiorImageId);
            InteriorImage image = interiorImageRepository.findById(key).orElse(new InteriorImage(email, interiorImageId));

            // Update texture and wall colors
            image.setTexture((String) data.get("texture"));
            image.setWallColorKMeans(data.get("wallColorKMeans").toString());
            image.setWallColorHistogram(data.get("wallColorHistogram").toString());
            image.setWallColorMedian(data.get("wallColorMedian").toString());
            List<List<Integer>> sampledColors = (List<List<Integer>>) data.get("sampledColors");
            // Check for null or list size before accessing elements
            if (sampledColors != null && sampledColors.size() >= 2) {
                image.setWallSampledColor1(sampledColors.get(0).toString());
                image.setWallSampledColor2(sampledColors.get(1).toString());
            } else {
                // Handle the case where there are no sampled colors
                image.setWallSampledColor1(null);
                image.setWallSampledColor2(null);
            }

            // Save the updated image
            interiorImageRepository.save(image);
            return ResponseEntity.ok("Data saved successfully!");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error saving data: " + e.getMessage());
        }
    }

    @PostMapping("/saveColors")
    public ResponseEntity<String> saveObjectsColors(@RequestBody List<Map<String, Object>> data) {
        try {
            for (Map<String, Object> item : data) {
                Map<String, Object> colorPackage = (Map<String, Object>) item.get("color_package");
                if (colorPackage != null) {
                    String email = (String) colorPackage.get("email");
                    int interiorImageId = (int) colorPackage.get("interiorImageId");
                    String objectName = (String) colorPackage.get("objectName");

                    // Find the existing interior image or create a new one
                    InteriorImageKey key = new InteriorImageKey(email, interiorImageId);
                    InteriorImage image = interiorImageRepository.findById(key).orElse(new InteriorImage(email, interiorImageId));
                    System.out.println(objectName+" is processing....");
                    // Map object name to fields dynamically
                    switch (objectName.toLowerCase()) {
                        case "floor":
                            image.setFloorColorKMeans(colorPackage.get("ColorKMeans").toString());
                            image.setFloorColorHistogram(colorPackage.get("ColorHistogram").toString());
                            image.setFloorColorMedian(colorPackage.get("ColorMedian").toString());
                            List<List<Integer>> floorSampledColors = (List<List<Integer>>) colorPackage.get("sampledColors");
                            // Check for null or list size before accessing elements
                            if (floorSampledColors != null && floorSampledColors.size() >= 2) {
                                image.setFloorSampledColor1(floorSampledColors.get(0).toString());
                                image.setFloorSampledColor2(floorSampledColors.get(1).toString());
                            } else {
                                // Handle the case where there are no sampled colors
                                image.setFloorSampledColor1(null);
                                image.setFloorSampledColor2(null);
                            }
                            break;

                        case "ceiling":
                            image.setCeilingColorKMeans(colorPackage.get("ColorKMeans").toString());
                            image.setCeilingColorHistogram(colorPackage.get("ColorHistogram").toString());
                            image.setCeilingColorMedian(colorPackage.get("ColorMedian").toString());
                            List<List<Integer>> CeilingSampledColors = (List<List<Integer>>) colorPackage.get("sampledColors");
                            // Check for null or list size before accessing elements
                            if (CeilingSampledColors != null && CeilingSampledColors.size() >= 2) {
                                image.setCeilingSampledColor1(CeilingSampledColors.get(0).toString());
                                image.setCeilingSampledColor2(CeilingSampledColors.get(1).toString());
                            } else {
                                // Handle the case where there are no sampled colors
                                image.setCeilingSampledColor1(null);
                                image.setCeilingSampledColor2(null);
                            }
                            break;

                        case "non_wall_area":
                            System.out.println(colorPackage);
                            image.setNonWallAreaColorKMeans(colorPackage.get("ColorKMeans").toString());
                            image.setNonWallAreaColorHistogram(colorPackage.get("ColorHistogram").toString());
                            image.setNonWallAreaColorMedian(colorPackage.get("ColorMedian").toString());
                            List<List<Integer>> CabinetSampledColors = (List<List<Integer>>) colorPackage.get("sampledColors");
                            // Check for null or list size before accessing elements
                            if (CabinetSampledColors != null && CabinetSampledColors.size() >= 2) {
                                image.setNonWallAreaSampledColor1(CabinetSampledColors.get(0).toString());
                                image.setNonWallAreaSampledColor2(CabinetSampledColors.get(1).toString());
                            } else {
                                // Handle the case where there are no sampled colors
                                image.setNonWallAreaSampledColor1(null);
                                image.setNonWallAreaSampledColor2(null);
                            }
                            break;

                        case "door":
                            image.setDoorColorKMeans(colorPackage.get("ColorKMeans").toString());
                            image.setDoorColorHistogram(colorPackage.get("ColorHistogram").toString());
                            image.setDoorColorMedian(colorPackage.get("ColorMedian").toString());
                            List<List<Integer>> DoorSampledColors = (List<List<Integer>>) colorPackage.get("sampledColors");
                            // Check for null or list size before accessing elements
                            if (DoorSampledColors != null && DoorSampledColors.size() >= 2) {
                                image.setDoorSampledColor1(DoorSampledColors.get(0).toString());
                                image.setDoorSampledColor2(DoorSampledColors.get(1).toString());
                            } else {
                                // Handle the case where there are no sampled colors
                                image.setDoorSampledColor1(null);
                                image.setDoorSampledColor2(null);
                            }
                            break;


                        case "table":
                            image.setTableColorKMeans(colorPackage.get("ColorKMeans").toString());
                            image.setTableColorHistogram(colorPackage.get("ColorHistogram").toString());
                            image.setTableColorMedian(colorPackage.get("ColorMedian").toString());
                            List<List<Integer>> TableSampledColors = (List<List<Integer>>) colorPackage.get("sampledColors");
                            // Check for null or list size before accessing elements
                            if (TableSampledColors != null && TableSampledColors.size() >= 2) {
                                image.setTableSampledColor1(TableSampledColors.get(0).toString());
                                image.setTableSampledColor2(TableSampledColors.get(1).toString());
                            } else {
                                // Handle the case where there are no sampled colors
                                image.setTableSampledColor1(null);
                                image.setTableSampledColor2(null);
                            }
                            break;

                        case "curtain":
                            image.setCurtainColorKMeans(colorPackage.get("ColorKMeans").toString());
                            image.setCurtainColorHistogram(colorPackage.get("ColorHistogram").toString());
                            image.setCurtainColorMedian(colorPackage.get("ColorMedian").toString());
                            List<List<Integer>> CurtainSampledColors = (List<List<Integer>>) colorPackage.get("sampledColors");
                            // Check for null or list size before accessing elements
                            if (CurtainSampledColors != null && CurtainSampledColors.size() >= 2) {
                                image.setCurtainSampledColor1(CurtainSampledColors.get(0).toString());
                                image.setCurtainSampledColor2(CurtainSampledColors.get(1).toString());
                            } else {
                                // Handle the case where there are no sampled colors
                                image.setCurtainSampledColor1(null);
                                image.setCurtainSampledColor2(null);
                            }
                            break;

                        case "chair":
                            image.setChairColorKMeans(colorPackage.get("ColorKMeans").toString());
                            image.setChairColorHistogram(colorPackage.get("ColorHistogram").toString());
                            image.setChairColorMedian(colorPackage.get("ColorMedian").toString());
                            List<List<Integer>> ChairSampledColors = (List<List<Integer>>) colorPackage.get("sampledColors");
                            // Check for null or list size before accessing elements
                            if (ChairSampledColors != null && ChairSampledColors.size() >= 2) {
                                image.setChairSampledColor1(ChairSampledColors.get(0).toString());
                                image.setChairSampledColor2(ChairSampledColors.get(1).toString());
                            } else {
                                // Handle the case where there are no sampled colors
                                image.setChairSampledColor1(null);
                                image.setChairSampledColor2(null);
                            }
                            break;

                        case "sofa":
                            image.setSofaColorKMeans(colorPackage.get("ColorKMeans").toString());
                            image.setSofaColorHistogram(colorPackage.get("ColorHistogram").toString());
                            image.setSofaColorMedian(colorPackage.get("ColorMedian").toString());
                            List<List<Integer>> SofaSampledColors = (List<List<Integer>>) colorPackage.get("sampledColors");
                            // Check for null or list size before accessing elements
                            if (SofaSampledColors != null && SofaSampledColors.size() >= 2) {
                                image.setSofaSampledColor1(SofaSampledColors.get(0).toString());
                                image.setSofaSampledColor2(SofaSampledColors.get(1).toString());
                            } else {
                                // Handle the case where there are no sampled colors
                                image.setSofaSampledColor1(null);
                                image.setSofaSampledColor2(null);
                            }
                            break;

                        case "screen":
                            image.setScreenColorKMeans(colorPackage.get("ColorKMeans").toString());
                            image.setScreenColorHistogram(colorPackage.get("ColorHistogram").toString());
                            image.setScreenColorMedian(colorPackage.get("ColorMedian").toString());
                            List<List<Integer>> ScreenSampledColors = (List<List<Integer>>) colorPackage.get("sampledColors");
                            // Check for null or list size before accessing elements
                            if (ScreenSampledColors != null && ScreenSampledColors.size() >= 2) {
                                image.setScreenSampledColor1(ScreenSampledColors.get(0).toString());
                                image.setScreenSampledColor2(ScreenSampledColors.get(1).toString());
                            } else {
                                // Handle the case where there are no sampled colors
                                image.setScreenSampledColor1(null);
                                image.setScreenSampledColor2(null);
                            }
                            break;

                        case "swivel":
                            image.setSwivelColorKMeans(colorPackage.get("ColorKMeans").toString());
                            image.setSwivelColorHistogram(colorPackage.get("ColorHistogram").toString());
                            image.setSwivelColorMedian(colorPackage.get("ColorMedian").toString());
                            List<List<Integer>> SwivelSampledColors = (List<List<Integer>>) colorPackage.get("sampledColors");
                            // Check for null or list size before accessing elements
                            if (SwivelSampledColors != null && SwivelSampledColors.size() >= 2) {
                                image.setSwivelSampledColor1(SwivelSampledColors.get(0).toString());
                                image.setSwivelSampledColor2(SwivelSampledColors.get(1).toString());
                            } else {
                                // Handle the case where there are no sampled colors
                                image.setSwivelSampledColor1(null);
                                image.setSwivelSampledColor2(null);
                            }
                            break;

                    }

                    // Save the updated image
                    interiorImageRepository.save(image);
                }
            }
            return ResponseEntity.ok("Data saved successfully!");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error saving data: " + e.getMessage());
        }

    }
}