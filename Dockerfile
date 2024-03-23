FROM wordpress:latest

# Install dependencies required for Composer + VIM
RUN apt-get update && apt-get install -y git unzip vim

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the Composer home directory
ENV COMPOSER_HOME=/usr/local/share/composer

# Install Global Ray package
RUN composer global require spatie/global-ray

# Add composer global bin directory to PATH, so the installed packages are available system-wide
ENV PATH="${PATH}:$COMPOSER_HOME/vendor/bin"

# Add auto_prepend.ini file if the Global Ray package is installed, which replaces the `global-ray install` command
RUN if [ -d "$COMPOSER_HOME/vendor/spatie/global-ray" ]; then echo "auto_prepend_file = $COMPOSER_HOME/vendor/spatie/global-ray/src/scripts/global-ray-loader.php" >> /usr/local/etc/php/conf.d/auto_prepend.ini; fi
