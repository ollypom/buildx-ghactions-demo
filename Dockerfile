# Compile Image 
######################
FROM python:3.7-slim AS compile-image

# Install Python Packages
WORKDIR /app
COPY service/requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --user -r requirements.txt

# Run Image
######################
FROM gcr.io/distroless/python3-debian10 AS run-image

# Add Labels
LABEL maintainer=olly@example.com
EXPOSE 8080

# Specify a Non Root User
USER nobody

# Define a Healthcheck
HEALTHCHECK --interval=10s --timeout=10s --start-period=30s \
  CMD ["python", "healthcheck.py"]

# Copy Installed Packages from Compile Image
ENV PYTHONPATH=/usr/local/lib/python3.7/site-packages
COPY --from=compile-image /root/.local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages

# Copy Application Code
WORKDIR /MythicalMysfitsService
COPY ./service .

# Configure Run Commands
CMD ["mythicalMysfitsService.py"]
