# Use official Python image
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy app files to the container
COPY . /app

# Install dependencies
RUN pip install -r /app/requirements.txt

# Expose Flask's default port
EXPOSE 5000

# Run the Flask app
CMD ["python", "/app/app.py"]
