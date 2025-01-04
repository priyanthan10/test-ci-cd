# Use the official Apache2 image as the base
FROM httpd:latest

# Copy your HTML files to the Apache web directory
COPY ./ /usr/local/apache2/htdocs/

# Expose port 80
EXPOSE 80