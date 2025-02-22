cd /path/to/unzipped/project-folder
python -m venv venv
# Activate the environment:
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate
pip install -r requirements.txt
python app.py
