# Use the official Apache HTTP Server image from Docker Hub
FROM httpd:2.4

# Copy the static HTML page to the default Apache directory
COPY ./index.html /usr/local/apache2/htdocs/