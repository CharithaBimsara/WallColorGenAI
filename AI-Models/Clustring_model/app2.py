import joblib
import numpy as np
import mysql.connector
import tkinter as tk
from tkinter import ttk

# Load the pre-trained K-means clustering model
kmeans = joblib.load('kmeans_color_model.pkl')

# Load the pre-trained MultiLabelBinarizer encoder
mlb = joblib.load('mlb_encoder.pkl')

# Define available options for each question
color_options = ['Red', 'Green', 'Blue', 'Yellow', 'Pink', 'Purple', 'Magenta', 'Grey', 'White', 'Black', 'Brown',
                'Orange', 'Turquoise', 'Teal', 'Lavender', 'Navy', 'Beige', 'Coral', 'Mint', 'Peach', 'Gold', 'Silver']
tone_options = ['Neutral', 'Cool Tones', 'Warm Tones', 'Mixed/Balanced', 'No Specific Color Scheme']
climate_options = ['Dry', 'Wet', 'Intermediate']
ambiance_options = ['Cozy and Warm', 'Bright and Airy', 'Elegant and Sophisticated', 
                    'Modern and Minimalist', 'Vibrant and Energetic']
family_options = ['1 - 2', '2 - 6', 'Above 6']
lifestyle_options = ['Homies', 'Job-runners', 'Party-lovers']
light_options = ['Natural light', 'Rich colors']
gender_options = ['Male', 'Female', 'Prefer not to say']
style_options = ['Modern', 'Traditional', 'Minimalist']
budget_options = ['Low Budget', 'Moderate Budget', 'High Budget']
photosensitivity_options = ['Yes', 'No']

# Create the main window
root = tk.Tk()
root.title("Color Preferences Clustering")
root.configure(bg='#f0f0f0')  # Set a light background color

# Create the input form
frame = tk.Frame(root, bg='#f0f0f0', padx=20, pady=20)
frame.grid(row=0, column=0, sticky=(tk.N, tk.S, tk.E, tk.W))

# Email input
email_label = ttk.Label(frame, text="Email:", background='#f0f0f0', foreground='#333333')
email_label.grid(row=0, column=0, sticky=tk.E)
email_entry = ttk.Entry(frame, font=('Arial', 12))
email_entry.grid(row=0, column=1, sticky=(tk.W, tk.E))

# Color preferences input (using Listbox for multiple selection)
color_label = ttk.Label(frame, text="Color Preferences:", background='#f0f0f0', foreground='#333333')
color_label.grid(row=1, column=0, sticky=tk.E)
color_listbox = tk.Listbox(frame, selectmode=tk.MULTIPLE, height=10, font=('Arial', 12), exportselection=False)
for color in color_options:
    color_listbox.insert(tk.END, color)
color_listbox.grid(row=1, column=1, sticky=(tk.W, tk.E))

# Tone preference input
tone_label = ttk.Label(frame, text="Color Tone:", background='#f0f0f0', foreground='#333333')
tone_label.grid(row=2, column=0, sticky=tk.E)
tone_combobox = ttk.Combobox(frame, values=tone_options, font=('Arial', 12))
tone_combobox.grid(row=2, column=1, sticky=(tk.W, tk.E))

# Climate preference input
climate_label = ttk.Label(frame, text="Climate:", background='#f0f0f0', foreground='#333333')
climate_label.grid(row=3, column=0, sticky=tk.E)
climate_combobox = ttk.Combobox(frame, values=climate_options, font=('Arial', 12))
climate_combobox.grid(row=3, column=1, sticky=(tk.W, tk.E))

# Ambiance preference input
ambiance_label = ttk.Label(frame, text="Ambiance:", background='#f0f0f0', foreground='#333333')
ambiance_label.grid(row=4, column=0, sticky=tk.E)
ambiance_combobox = ttk.Combobox(frame, values=ambiance_options, font=('Arial', 12))
ambiance_combobox.grid(row=4, column=1, sticky=(tk.W, tk.E))

# Family size input
family_label = ttk.Label(frame, text="Family Size:", background='#f0f0f0', foreground='#333333')
family_label.grid(row=5, column=0, sticky=tk.E)
family_combobox = ttk.Combobox(frame, values=family_options, font=('Arial', 12))
family_combobox.grid(row=5, column=1, sticky=(tk.W, tk.E))

# Lifestyle input
lifestyle_label = ttk.Label(frame, text="Lifestyle:", background='#f0f0f0', foreground='#333333')
lifestyle_label.grid(row=6, column=0, sticky=tk.E)
lifestyle_combobox = ttk.Combobox(frame, values=lifestyle_options, font=('Arial', 12))
lifestyle_combobox.grid(row=6, column=1, sticky=(tk.W, tk.E))

# Light preference input
light_label = ttk.Label(frame, text="Light Preference:", background='#f0f0f0', foreground='#333333')
light_label.grid(row=7, column=0, sticky=tk.E)
light_combobox = ttk.Combobox(frame, values=light_options, font=('Arial', 12))
light_combobox.grid(row=7, column=1, sticky=(tk.W, tk.E))

# Gender input
gender_label = ttk.Label(frame, text="Gender:", background='#f0f0f0', foreground='#333333')
gender_label.grid(row=8, column=0, sticky=tk.E)
gender_combobox = ttk.Combobox(frame, values=gender_options, font=('Arial', 12))
gender_combobox.grid(row=8, column=1, sticky=(tk.W, tk.E))

# Style preference input
style_label = ttk.Label(frame, text="Architectural Style:", background='#f0f0f0', foreground='#333333')
style_label.grid(row=9, column=0, sticky=tk.E)
style_combobox = ttk.Combobox(frame, values=style_options, font=('Arial', 12))
style_combobox.grid(row=9, column=1, sticky=(tk.W, tk.E))

# Budget input
budget_label = ttk.Label(frame, text="Budget:", background='#f0f0f0', foreground='#333333')
budget_label.grid(row=10, column=0, sticky=tk.E)
budget_combobox = ttk.Combobox(frame, values=budget_options, font=('Arial', 12))
budget_combobox.grid(row=10, column=1, sticky=(tk.W, tk.E))

# Photosensitivity input
photosensitivity_label = ttk.Label(frame, text="Photosensitive:", background='#f0f0f0', foreground='#333333')
photosensitivity_label.grid(row=11, column=0, sticky=tk.E)
photosensitivity_combobox = ttk.Combobox(frame, values=photosensitivity_options, font=('Arial', 12))
photosensitivity_combobox.grid(row=11, column=1, sticky=(tk.W, tk.E))

# Submit button
submit_button = ttk.Button(frame, text="Submit", command=lambda: submit_form(), style='Primary.TButton')
submit_button.grid(row=12, column=0, columnspan=2, pady=10)

# Function to handle form submission
def submit_form():
    user_email = email_entry.get()
    # Get the selected colors from the Listbox (multiple selections)
    selected_colors = [color_options[i] for i in color_listbox.curselection()]
    
    user_tone = tone_combobox.get()
    user_climate = climate_combobox.get()
    user_ambiance = ambiance_combobox.get()
    user_family_size = family_combobox.get()
    user_lifestyle = lifestyle_combobox.get()
    user_light_preference = light_combobox.get()
    user_gender = gender_combobox.get()
    user_style = style_combobox.get()
    user_budget = budget_combobox.get()
    user_photosensitivity = photosensitivity_combobox.get()

    # Encode user color preferences using the MultiLabelBinarizer
    user_colors_encoded = mlb.transform([selected_colors])[0]

    # Combine user preferences as features (this example only uses color preferences)
    user_features = user_colors_encoded

    # Predict the user's cluster
    try:
        user_cluster = str(kmeans.predict([user_features])[0])
        print(f"Predicted Cluster for User: Cluster {user_cluster}")

        # Connect to the MySQL database
        db = mysql.connector.connect(
            host="54.221.51.240",
            user="theuser",
            password="thepassword",
            database="newdbnexa"
        )

        # Create a cursor object
        cursor = db.cursor()

        # Insert the predicted cluster into the database
        sql = "UPDATE client SET user_group = %s WHERE email = %s"
        values = (user_cluster, user_email)
        cursor.execute(sql, values)

        # Commit the changes and close the connection
        db.commit()
        db.close()

        # Display cluster group
        Cluster_label = ttk.Label(frame, text=f"Your Group is : {user_cluster}", foreground='#008000', background='#f0f0f0')
        Cluster_label.grid(row=13, column=0, columnspan=2, pady=10)


        # Display a success message
        success_label = ttk.Label(frame, text="Cluster prediction saved successfully!", foreground='#008000', background='#f0f0f0')
        success_label.grid(row=14, column=0, columnspan=2, pady=10)

    except Exception as e:
        # Display an error message
        error_label = ttk.Label(frame, text=f"Error: {str(e)}", foreground='#ff0000', background='#f0f0f0')
        error_label.grid(row=14, column=0, columnspan=2, pady=10)

    # Clear the input fields
    email_entry.delete(0, tk.END)
    color_listbox.selection_clear(0, tk.END)
    tone_combobox.set('')
    climate_combobox.set('')
    ambiance_combobox.set('')
    family_combobox.set('')
    lifestyle_combobox.set('')
    light_combobox.set('')
    gender_combobox.set('')
    style_combobox.set('')
    budget_combobox.set('')
    photosensitivity_combobox.set('')

# Apply a nicer style to the GUI
style = ttk.Style()
style.theme_use('clam')
style.configure('TButton', background='#0077b6', foreground='white', font=('Arial', 12, 'bold'))
style.configure('TLabel', background='#f0f0f0', foreground='#333333', font=('Arial', 12))
style.configure('TCombobox', font=('Arial', 12))

root.mainloop()