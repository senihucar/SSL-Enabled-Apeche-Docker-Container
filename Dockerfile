FROM httpd:2.4-alpine

RUN mkdir -p /usr/local/apache2/htdocs/test/
RUN chown -R www-data:www-data /usr/local/apache2/htdocs/test/

# Copy website files
COPY ./html/index.html /usr/local/apache2/htdocs/test

# Copy SSL certificates
COPY ./ssl/hostname.key /usr/local/apache2/conf/hostname.key
COPY ./ssl/hostname.crt /usr/local/apache2/conf/hostname.crt

# Copy custom configuration files
COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./ssl.conf /usr/local/apache2/conf.d/ssl.conf

# Install required packages for SSL (IF SSL NOT CREATED)
#RUN apk add --no-cache openssl && \
#    openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
#    -subj "/C=US/ST=CA/L=SanFrancisco/O=MyOrg/OU=MyDept/CN=mydomain.com" \
#    -keyout /usr/local/apache2/conf/server.key \
#    -out /usr/local/apache2/conf/server.crt

# Set permissions
RUN chown -R www-data:www-data /usr/local/apache2/htdocs && \
    chmod 755 /usr/local/apache2/htdocs && \
    chown -R root:www-data /usr/local/apache2/conf/httpd.conf && \
    chmod 644 /usr/local/apache2/conf/httpd.conf && \
    chown -R root:www-data /usr/local/apache2/conf.d/ssl.conf && \
    chmod 644 /usr/local/apache2/conf.d/ssl.conf && \
    chown -R root:www-data /usr/local/apache2/conf/hostname.key && \
    chmod 600 /usr/local/apache2/conf/hostname.key && \
    chown -R root:www-data /usr/local/apache2/conf/hostname.crt && \
    chmod 600 /usr/local/apache2/conf/hostname.crt

# Add user for authentication
RUN apk add --no-cache apache2-utils && \
    htpasswd -cb /usr/local/apache2/conf/.htpasswd test test123

EXPOSE 80 443

# Start Apache
CMD ["httpd-foreground"]
