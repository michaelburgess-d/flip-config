* opacity on login
* seperate per-client git repo for markdown 
* consider role of system for lxd/dev/etc.
    * eg., they can run gh auth login 
    
```

server {
    listen 80;
    server_name your_domain.com; # Replace with your domain name

    location /submit-courseware {
        # requires admin cookie... 
    }

    location /refresh-courseware {
        fastcgi_pass 127.0.0.1:9000;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /var/www/html/update.sh; # Path to your Bash script
    }

    # Add other server configuration directives as needed
}

```