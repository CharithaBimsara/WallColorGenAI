import joblib
import numpy as np
import mysql.connector
import tkinter as tk
from tkinter import ttk
import warnings



# Load the pre-trained K-means clustering model
kmeans = joblib.load('kmeans_color_model.pkl')
mlb = joblib.load('mlb_encoder.pkl')

# Database connection details
DB_HOST = "54.221.51.240"
DB_USER = "theuser"
DB_PASSWORD = "thepassword"
DB_NAME = "nexa"

# Create the main window
root = tk.Tk()
root.title("Color Preferences Clustering")
root.configure(bg='#0f0f0f')

# Create the input form
frame = tk.Frame(root, bg='#0f0f0f', padx=20, pady=20)
frame.grid(row=0, column=0, sticky=(tk.N, tk.S, tk.E, tk.W))

# Email input using tk.Entry for styling
email_label = ttk.Label(frame, text="Email:", background='#0f0f0f', foreground='#00ff00')
email_label.grid(row=0, column=0, sticky=tk.E)
email_entry = tk.Entry(frame, font=('Courier', 12), background='#0f0f0f', foreground='#00ff00', insertbackground='#00ff00')
email_entry.grid(row=0, column=1, sticky=(tk.W, tk.E))

# Processing label to show real-time status
processing_label = tk.Label(frame, text="", font=('Courier', 10), background='#0f0f0f', foreground='#00ff00')
processing_label.grid(row=2, column=0, columnspan=2, pady=10)

# If code not running well plase comment this and then you can see the warnings
warnings.filterwarnings("ignore", module="sklearn")

# Define each processing step with delays between them
def start_processing(email):
    # Step 1: Connecting to the database
    update_status("Connecting to secure database...")
    root.after(1000, lambda: connect_to_database(email))

def connect_to_database(email):
    try:
        db = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
        update_status("Connected to database successfully!")
        root.after(1000, lambda: fetch_preferences(db, email))
    except mysql.connector.Error as err:
        update_status(f"Database connection failed: {err}")

def fetch_preferences(db, email):
    # Step 2: Fetch user preferences
    update_status("Fetching user preferences...")
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM client_preferences WHERE email = %s", (email,))
    user_data = cursor.fetchone()
    
    if not user_data:
        update_status("Email not found in database.")
        db.close()
        return

    update_status("User preferences fetched successfully.")
    root.after(1000, lambda: process_data(db, user_data, email))

def process_data(db, user_data, email):
    # Step 3: Process and map data
    update_status("Processing data...")
    user_preferences = {
        "user_style": user_data.get("architectural_style"),
        "budget": user_data.get("budget"),
        "user_climate": user_data.get("climate"),
        "user_tone": user_data.get("color_tone_theme"),
        "selected_colors": user_data.get("favorite_colors", "").split(", "),
        "user_lifestyle": user_data.get("lifestyle"),
        "user_light_preference": "Natural light" if user_data.get("natural_light_checked") == 1 else "Rich colors",
        "user_family_size": user_data.get("number_of_members"),
        "user_photosensitivity": "Yes" if user_data.get("photosensitivity") == 1 else "No",
        "user_ambiance": user_data.get("preferred_ambiance")
    }
    root.after(1000, lambda: analyze_color_preferences(db, user_preferences, email))

def analyze_color_preferences(db, user_preferences, email):
    # Step 4: Encode color preferences and analyze
    update_status("Analyzing color preferences...")
    user_colors_encoded = mlb.transform([user_preferences["selected_colors"]])[0]
    user_features = user_colors_encoded
    root.after(1000, lambda: run_clustering_model(db, user_features, email))

def run_clustering_model(db, user_features, email):
    # Step 5: Run clustering model
    update_status("Running clustering model...")
    user_cluster = str(kmeans.predict([user_features])[0])
    root.after(1000, lambda: update_database(db, user_cluster, email))

def update_database(db, user_cluster, email):
    # Step 6: Update cluster group in the database
    update_status("Updating database with cluster result...")
    cursor = db.cursor()
    cursor.execute("UPDATE client SET user_group = %s WHERE email = %s", (user_cluster, email))
    db.commit()
    db.close()
    update_status("Database updated successfully.")
    root.after(1000, lambda: display_final_result(user_cluster))

def display_final_result(user_cluster):
    # Step 7: Display final result
    processing_label.config(text=f"Your Group is: Cluster {user_cluster}\nProcess complete!")

# Function to update the processing label in real-time
def update_status(message):
    processing_label.config(text=message)
    root.update_idletasks()  # Refresh the interface

# Function triggered by submit button
def on_submit():
    email = email_entry.get()
    processing_label.config(text="")  # Clear any previous messages
    start_processing(email)

# Submit button
submit_button = ttk.Button(frame, text="Submit", command=on_submit, style='Primary.TButton')
submit_button.grid(row=1, column=0, columnspan=2, pady=10)

# Apply "hacking" style to the GUI
style = ttk.Style()
style.theme_use('clam')
style.configure('TButton', background='#00ff00', foreground='black', font=('Courier', 12, 'bold'))
style.configure('TLabel', background='#0f0f0f', foreground='#00ff00', font=('Courier', 12))
style.configure('TCombobox', font=('Courier', 12))

root.mainloop()