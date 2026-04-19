FROM python:3.12-alpine

WORKDIR /app

# Copy only requirements first (for caching efficiency)
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

ENTRYPOINT ["python"]
CMD ["app.py"]