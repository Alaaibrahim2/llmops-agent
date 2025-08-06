FROM python:3.10-slim

# Essential environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Work directory inside the docker container
WORKDIR /app

# Installing system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better Docker layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all application code
COPY . .

# Set Python path to include the app directory
ENV PYTHONPATH=/app


# Expose ports
EXPOSE 8501
EXPOSE 9999

# Run the application
CMD ["python", "-m", "app.main"]