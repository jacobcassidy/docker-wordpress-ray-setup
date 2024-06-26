# Docker WordPress & Ray Setup

This repository contains the files needed to quickly get up and running with a local WordPress development Docker container. The container uses the official Docker __wordpress image__ for the server, __MySQL__ for the database, __local volumes__ for live editing of the files and database, and the composer __Global Ray__ package for connecting with the [Ray desktop app](https://myray.app/) for debugging.

Included below are one-time setup instructions for creating a __standalone NGINX Reverse Proxy Docker network__. The network container will allow you to run multiple local servers simultaneously, all using unique local domain names on the standard 80 (HTTP) or 443 (HTTPS) ports. This removes the need to manage port numbers, gives you clean domains to work from (no appended port number), and manages running your local domains on the HTTPS protocol with self-created TLS certificates.

## Other Docker Container Setup Repositories

Depending on what stack you're using and whether you use [Ray](https://myray.app/) for debugging, another setup may be a better fit:

| Setups without the Global Ray package| Setups with the Global Ray package |
| - | - |
| [NGINX, PHP-FPM & MySQL](https://github.com/jacobcassidy/docker-nginx-phpfpm-setup) | [NGINX, PHP-FPM, MySQL, & Ray](https://github.com/jacobcassidy/docker-nginx-phpfpm-ray-setup) |
| [WordPress & MySQL](https://github.com/jacobcassidy/docker-wordpress-setup) | [WordPress, MySQL, & Ray](https://github.com/jacobcassidy/docker-wordpress-ray-setup) |

## Instructions

### First Time Setup

For all features to work, you must do a one-time setup of the following:

1. Install the [Docker Nginx Proxy Setup](https://github.com/jacobcassidy/docker-nginx-proxy-setup).
2. Connect the Docker host with your local machine so Docker can communicate with the Ray desktop app by adding `127.0.0.1 host.docker.internal` to your local machine's _/etc/hosts_ file.

### Project Setup

1. In the parent directory where you want your project directory nested, run `git clone git@github.com:jacobcassidy/docker-wordpress-ray-setup.git`.
2. Rename the cloned directory from `docker-wordpress-ray-setup` to your project name.
3. Rename the `.env-example` file to `.env`.
4. Update the `.env` file with the values your project will use.
5. In the `nginx-proxy-base/certs` directory you created in step one of the __First Time Setup__ instructions above, create the TLS certificates needed for the HTTPS protocol using the command: `mkcert yourlocaldomain.tld`. Ensure you replace "yourlocaldomain.tld" with the local domain name you specified in your `.env` file.
6. Rename the created TLS certificates:
    | FROM | TO |
    | - | - |
    | yourlocaldomain.tld-key.pem | yourlocaldomain.tld.key |
    | yourlocaldomain.tld.pem | yourlocaldomain.tld.crt |
7. Add yourlocaldomain.tld to your local machine's hosts file. This can be done on macOS with: `sudo vim /etc/hosts` and adding `127.0.0.1 yourlocaldomain.tld` to the list (make sure to replace yourlocaldomain.tld with your actual domain name).
8. Open the [Docker Desktop](https://www.docker.com/products/docker-desktop/) app so the Docker engine is on.
9. In your project directory, run `docker compose up -d` to build the WordPress Docker container. This will start your server and add the following directories to your project directory:
    - `/html`: contains the WordPress files.
    - `/log`: will contain the `wp-errors.log` file when WordPress has an error (the directory will be empty until there's an error).
    - `/storage/mysql`: contains the database.
10. Replace this README content with your project's README content (you can view the original README [here](https://github.com/jacobcassidy/docker-wordpress-ray-setup)).
11. Optional: Remove the cloned _docker-wordpress-setup_ __.git__ directory with: `rm -rf .git` (run this command from your project directory).
12. Optional: Initialize a new git repository for your project with: `git init`.
13. Optional: If you will be using a GitHub remote repo, create and connect to it now.
14. Open your browser to the local domain specified in your `.env` file and complete the WordPress installation.

## Note about the REST API

- If your site is not connecting to the REST API (such as when you view https://yourdomain.local/wp-json/wp/v2/types/post), go to `WP Admin > Settings > Permalinks` and select one of the "pretty" link options. If you already have one selected, simply press the save button again, and your REST API endpoint should work again.

If you see "The REST API encountered an error" or "Your site could not complete a loopback request", ensure you are NOT using ".localhost" as your TLD (since cURL version 7.85.0, domains ending in _.localhost_ can no longer resolve to an external IP), and confirm your `PROXY_NETWORK_GATEWAY` setting in the `.env` file is using the correct Docker network IP (see instructions in the .env file). If you change the settings in the `.env` file, rebuild your container with `docker compose up -d --build`.

## Issues?

If you come across any issues, please feel free to report them [here](https://github.com/jacobcassidy/docker-wordpress-ray-setup/issues).
