import cv2
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
from scipy.stats import entropy
import skfuzzy as fuzz
import skfuzzy.control as ctrl
import boto3
import io
import json
import os
from datetime import datetime
import mysql.connector
from urllib.parse import urlparse


# Database configuration
DB_CONFIG = {
    'database': 'nexa',
    'user': 'theuser',
    'password': 'thepassword',
    'host': '54.221.51.240',
    'port': '3306'
}


# Initialize S3 client
s3_client = boto3.client('s3')



# # Initialize S3 client
# s3_client = boto3.client('s3')
# BUCKET_NAME = 'complexitybucket'
# INPUT_PREFIX = 'input-images/'
# OUTPUT_PREFIX = 'analysis-results/'


def get_image_url_from_db(image_id):
    """Fetch image URL from MySQL database based on image ID"""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        query = "SELECT interior_image_url FROM interior_image WHERE interior_image_id = %s"
        cursor.execute(query, (image_id,))
        result = cursor.fetchone()
        
        cursor.close()
        conn.close()
        
        return result[0] if result else None
    except mysql.connector.Error as e:
        print(f"Database error while fetching image URL: {str(e)}")
        return None


def update_complexity_score(image_id, complexity_score):
    """Update complexity score in MySQL database"""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        query = "UPDATE interior_image SET complexity_score = %s WHERE interior_image_id = %s"
        cursor.execute(query, (complexity_score, image_id))
        conn.commit()
        
        cursor.close()
        conn.close()
        
        print(f"Successfully updated complexity score for image ID: {image_id}")
    except mysql.connector.Error as e:
        print(f"Database error while updating complexity score: {str(e)}")


def download_image_from_s3(image_url):
    """Download image from S3 bucket using the full URL"""
    try:
        # Parse S3 URL to get bucket and key
        parsed_url = urlparse(image_url)
        bucket = parsed_url.netloc.split('.')[0]
        key = parsed_url.path.lstrip('/')
        
        # Get object from S3
        response = s3_client.get_object(Bucket=bucket, Key=key)
        image_content = response['Body'].read()
        
        # Convert S3 image to numpy array
        nparr = np.frombuffer(image_content, np.uint8)
        image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        return image
    except Exception as e:
        print(f"Error downloading image from S3: {str(e)}")
        return None

def process_single_image(image_id, room_width, room_height):
    """Process a single image based on image ID"""
    try:
        # Get image URL from database
        image_url = get_image_url_from_db(image_id)
        if not image_url:
            print(f"No image found for ID: {image_id}")
            return
            
        # Download image from S3
        print(f"Downloading image for ID: {image_id}")
        image = download_image_from_s3(image_url)
        
        if image is None:
            print(f"Failed to download image for ID: {image_id}")
            return
        
        # Resize image for marking objects
        resized_image = resize_image(image)
        
        # User marks objects
        print("\nPlease mark the objects in the image...")
        rois = user_mark_objects(resized_image)
        
        # Calculate complexity scores
        area_based_score = calculate_area_based_complexity_score(rois, room_width, room_height, resized_image)
        gray_image = cv2.cvtColor(resized_image, cv2.COLOR_BGR2GRAY)
        entropy_based_score = calculate_entropy_based_complexity_score(gray_image, rois)
        visual_clutter_score = calculate_visual_clutter_score(rois, gray_image.shape)
        
        # Calculate final complexity
        final_score, complexity_level = calculate_complexity_and_determine_level(
            area_based_score, entropy_based_score, visual_clutter_score)
        
        # Update complexity score in database with the final_score instead of complexity_level
        update_complexity_score(image_id, final_score)
        
        # Print results
        print("\nAnalysis Results:")
        print(f"Area-Based Complexity Score: {area_based_score:.2f}")
        print(f"Entropy-Based Complexity Score: {entropy_based_score:.2f}")
        print(f"Visual Clutter Score: {visual_clutter_score:.2f}")
        print(f"Final Complexity Score: {final_score:.2f}")
        print(f"Complexity Level: {complexity_level}")
        
    except Exception as e:
        print(f"Error processing image {image_id}: {str(e)}")

# def download_image_from_s3(image_key):
#     """Download image from S3 bucket and convert to OpenCV format"""
#     try:
#         response = s3_client.get_object(Bucket=BUCKET_NAME, Key=f"{INPUT_PREFIX}{image_key}")
#         image_content = response['Body'].read()
        
#         # Convert S3 image to numpy array
#         nparr = np.frombuffer(image_content, np.uint8)
#         image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
#         return image
#     except Exception as e:
#         print(f"Error downloading image from S3: {str(e)}")
#         return None


def save_results_to_s3(image_name, results, marked_image):
    """Save analysis results and marked image to S3"""
    try:
        # Create a timestamp for unique naming
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # Save marked image
        _, buffer = cv2.imencode('.jpg', marked_image)
        image_key = f"{OUTPUT_PREFIX}{image_name}/marked_image_{timestamp}.jpg"
        s3_client.put_object(
            Bucket=BUCKET_NAME,
            Key=image_key,
            Body=buffer.tobytes(),
            ContentType='image/jpeg'
        )
        
        # Save analysis results as JSON
        results_key = f"{OUTPUT_PREFIX}{image_name}/analysis_results_{timestamp}.json"
        s3_client.put_object(
            Bucket=BUCKET_NAME,
            Key=results_key,
            Body=json.dumps(results, indent=4),
            ContentType='application/json'
        )
        
        print(f"Results saved to S3:\nMarked image: {image_key}\nAnalysis results: {results_key}")
    except Exception as e:
        print(f"Error saving results to S3: {str(e)}")


def calculate_complexity_and_determine_level(area_based_complexity_score, entropy_based_complexity_score, visual_clutter_score):
    """Calculate final complexity score and level using fuzzy logic"""
    # Define the ranges for the inputs
    area_range = np.arange(0, 1.1, 0.1)
    entropy_range = np.arange(0, 1.1, 0.1)
    clutter_range = np.arange(0, 1.1, 0.1)
    complexity_range = np.arange(0, 1.1, 0.1)

    # Define membership functions
    area = ctrl.Antecedent(area_range, 'area')
    entropy = ctrl.Antecedent(entropy_range, 'entropy')
    clutter = ctrl.Antecedent(clutter_range, 'clutter')
    complexity = ctrl.Consequent(complexity_range, 'complexity')

    # Define the membership functions
    area['low'] = fuzz.trimf(area_range, [0, 0, 0.35])
    area['high'] = fuzz.trimf(area_range, [0.35, 1, 1])
    
    entropy['low'] = fuzz.trimf(entropy_range, [0, 0, 0.13])
    entropy['high'] = fuzz.trimf(entropy_range, [0.13, 1, 1])
    
    clutter['low'] = fuzz.trimf(clutter_range, [0, 0, 0.12])
    clutter['high'] = fuzz.trimf(clutter_range, [0.12, 1, 1])
    
    complexity['low'] = fuzz.trimf(complexity_range, [0, 0, 0.5])
    complexity['high'] = fuzz.trimf(complexity_range, [0.5, 1, 1])

    # Define rules
    rules = [
        ctrl.Rule(area['low'] & entropy['low'] & clutter['low'], complexity['low']),
        ctrl.Rule(area['low'] & entropy['low'] & clutter['high'], complexity['low']),
        ctrl.Rule(area['low'] & entropy['high'] & clutter['low'], complexity['low']),
        ctrl.Rule(area['low'] & entropy['high'] & clutter['high'], complexity['low']),
        ctrl.Rule(area['high'] & entropy['low'] & clutter['low'], complexity['high']),
        ctrl.Rule(area['high'] & entropy['low'] & clutter['high'], complexity['high']),
        ctrl.Rule(area['high'] & entropy['high'] & clutter['low'], complexity['high']),
        ctrl.Rule(area['high'] & entropy['high'] & clutter['high'], complexity['high'])
    ]

    # Create and simulate the control system
    complexity_ctrl = ctrl.ControlSystem(rules)
    complexity_sim = ctrl.ControlSystemSimulation(complexity_ctrl)

    # Input the scores
    complexity_sim.input['area'] = area_based_complexity_score
    complexity_sim.input['entropy'] = entropy_based_complexity_score
    complexity_sim.input['clutter'] = visual_clutter_score
    
    # Compute
    complexity_sim.compute()
    output_complexity = complexity_sim.output['complexity']

    # Determine complexity level
    complexity_low_val = fuzz.interp_membership(complexity_range, complexity['low'].mf, output_complexity)
    complexity_high_val = fuzz.interp_membership(complexity_range, complexity['high'].mf, output_complexity)
    
    complexity_level = 'High' if complexity_high_val > complexity_low_val else 'Low'
    
    return output_complexity, complexity_level


def process_image(image, image_name, room_width, room_height):
    """Process a single image and return its complexity analysis"""
    try:
        # Resize image for marking objects
        resized_image = resize_image(image)
        
        # User marks objects
        print(f"\nProcessing image: {image_name}")
        print("Please mark the objects in the image...")
        rois = user_mark_objects(resized_image)
        
        # Calculate complexity scores even if no objects were marked
        area_based_score = calculate_area_based_complexity_score(rois, room_width, room_height, resized_image)
        gray_image = cv2.cvtColor(resized_image, cv2.COLOR_BGR2GRAY)
        entropy_based_score = calculate_entropy_based_complexity_score(gray_image, rois)
        visual_clutter_score = calculate_visual_clutter_score(rois, gray_image.shape)
        
        # Calculate final complexity
        final_score, complexity_level = calculate_complexity_and_determine_level(
            area_based_score, entropy_based_score, visual_clutter_score)
        
        # Prepare results
        results = {
            "image_name": image_name,
            "room_dimensions": {
                "width": room_width,
                "height": room_height
            },
            "scores": {
                "area_based_complexity": float(area_based_score),
                "entropy_based_complexity": float(entropy_based_score),
                "visual_clutter": float(visual_clutter_score),
                "final_complexity_score": float(final_score),
                "complexity_level": complexity_level
            },
            "timestamp": datetime.now().isoformat()
        }
        
        return results, resized_image
    
    except Exception as e:
        print(f"Error processing image {image_name}: {str(e)}")
        return None, None

# Function to display an image
def display_image(title, image):
    plt.figure(figsize=(10, 8))
    plt.imshow(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
    plt.title(title)
    plt.axis('off')
    plt.show()

# Function to resize the image to fit within the screen
def resize_image(image, max_width=800, max_height=600):
    height, width = image.shape[:2]
    aspect_ratio = width / height

    if width > max_width:
        width = max_width
        height = int(width / aspect_ratio)
    
    if height > max_height:
        height = max_height
        width = int(height * aspect_ratio)
    
    resized_image = cv2.resize(image, (width, height))
    return resized_image

# Function to get user input for marking objects
def user_mark_objects(image):
    marked_image = image.copy()
    rois = []  # List to hold regions of interest

    print("Instructions: Click to mark the vertices of a polygon around each object. Right-click to close the polygon. Press 'Enter' to finish marking an object, and 'Esc' to finish all.")
    
    def line_drawer(event, x, y, flags, param):
        nonlocal rois, marked_image
        if event == cv2.EVENT_LBUTTONDOWN:  # Left click, select point
            cv2.circle(marked_image, (x, y), 5, (0, 255, 0), -1)
            points.append((x, y))
        elif event == cv2.EVENT_RBUTTONDOWN:  # Right click, close polygon
            if len(points) > 0:
                cv2.polylines(marked_image, [np.array(points)], True, (255, 0, 0), 2)
                rois.append(points.copy())
                points.clear()
        if points:
            cv2.polylines(marked_image, [np.array(points)], False, (0, 255, 0), 1)
        cv2.imshow('Mark Objects', marked_image)

    points = []
    cv2.imshow('Mark Objects', marked_image)
    cv2.setMouseCallback('Mark Objects', line_drawer)

    while True:
        key = cv2.waitKey(1) & 0xFF
        if key == 27:  # ESC to exit
            break

    cv2.destroyAllWindows()
    return rois

# Calculate the area-based complexity score
def calculate_area_based_complexity_score(rois, room_width, room_height, image):
    # Convert room dimensions from meters to pixels
    pixels_per_meter_x = image.shape[1] / room_width
    pixels_per_meter_y = image.shape[0] / room_height

    # Calculate total room area in pixel units
    total_room_area = pixels_per_meter_x * room_width * pixels_per_meter_y * room_height

    # Calculate total object area using polygons
    total_object_area = sum([cv2.contourArea(np.array(roi)) for roi in rois])
    
    total_overlap_area = 0.0
    
    image_shape = image.shape[:2]  # Use image shape here

    for i in range(len(rois)):
        for j in range(i + 1, len(rois)):
            poly1 = cv2.fillPoly(np.zeros(image_shape, dtype=np.uint8), [np.array(rois[i])], 1)
            poly2 = cv2.fillPoly(np.zeros(image_shape, dtype=np.uint8), [np.array(rois[j])], 1)
            overlap_area = np.sum((poly1 & poly2) > 0)
            total_overlap_area += overlap_area
    
    total_object_area_refine = total_object_area - total_overlap_area
    # Calculate space area
    space_area = total_room_area - total_object_area_refine

    # Calculate complexity score
    complexity_score = total_object_area_refine / (total_object_area_refine + space_area) if total_object_area_refine + space_area > 0 else 0
    return complexity_score

# Load an image and convert to grayscale
def load_image(image_path):
    image = Image.open(image_path)
    image = image.convert('L')  # Convert to grayscale
    return np.array(image)

# Calculate the entropy of an image
def calculate_entropy(image_array):
    histogram, _ = np.histogram(image_array, bins=256, range=(0, 255), density=True)
    return entropy(histogram)

# Normalize the entropy value
def normalize_entropy(entropy_value):
    max_entropy = np.log2(256)  # Maximum entropy for 8-bit image
    return entropy_value / max_entropy

# Calculate the entropy-based complexity score for marked objects
def calculate_entropy_based_complexity_score(image, rois):
    total_entropy = 0.0
    for roi in rois:
        mask = np.zeros(image.shape, dtype=np.uint8)
        cv2.fillPoly(mask, [np.array(roi)], 1)
        masked_image = image * mask
        entropy_value = calculate_entropy(masked_image)
        normalized_entropy = normalize_entropy(entropy_value)
        total_entropy += normalized_entropy * cv2.contourArea(np.array(roi))

    total_object_area = sum([cv2.contourArea(np.array(roi)) for roi in rois])
    entropy_based_complexity_score = total_entropy / total_object_area if total_object_area > 0 else 0
    return entropy_based_complexity_score

# Calculate the visual clutter score
def calculate_visual_clutter_score(rois, image_shape):
    total_overlap_area = 0.0
    total_density = 0.0
    total_object_area = sum([cv2.contourArea(np.array(roi)) for roi in rois])

    for i in range(len(rois)):
        for j in range(i + 1, len(rois)):
            poly1 = cv2.fillPoly(np.zeros(image_shape, dtype=np.uint8), [np.array(rois[i])], 1)
            poly2 = cv2.fillPoly(np.zeros(image_shape, dtype=np.uint8), [np.array(rois[j])], 1)
            overlap_area = np.sum((poly1 & poly2) > 0)
            total_overlap_area += overlap_area
    
    density = total_object_area / (image_shape[0] * image_shape[1])
    clutter_score = (total_overlap_area / total_object_area) * density if total_object_area > 0 else 0
    
    return clutter_score

def main():
    try:
        # Get image ID from user
        image_id = input("Enter the interior image ID to analyze: ")
        
        # Get room dimensions from user
        room_width = float(input("\nEnter the actual width of the room in meters: "))
        room_height = float(input("Enter the actual height of the room in meters: "))
        
        # Process the image
        process_single_image(image_id, room_width, room_height)
        
    except Exception as e:
        print(f"An error occurred in main: {str(e)}")
    
if __name__ == "__main__":
    main()
