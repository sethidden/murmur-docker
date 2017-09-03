# umurmur

[![Current tag](http://img.shields.io/github/tag/gp3t1/umurmur.svg)](https://github.com/gp3t1/umurmur/tags) 
[![Repository issues](http://issuestats.com/github/gp3t1/umurmur/badge/issue)](http://issuestats.com/github/gp3t1/umurmur) 

description

## Installation

1. Make sure you've installed docker
2. Run your custom umurmur instance using the following commands

## Usage

Here's a short explanation how to use `umurmur`:

* Run it with defaults parameters:
    This will create a new instance with no password and no admin access, exposed on your host on port 64738(TCP/UDP)
    ```sh
    docker run -ti -p 64738:64738 -p 64738:64738/udp umurmur:0.1
    ```

* If you want to customize your umurmur instance:
    + If you want to set a password:
    ```sh
    docker run -ti -p 64738:64738 -p 64738:64738/udp -e PASSWORD=<my-password> umurmur:0.1
    ```

    + You can pass basic umurmur settings in the same way.
    ```sh
    docker run -ti -p 64738:64738 -p 64738:64738/udp [-e VAR1=<my-value> [-e VAR2=<my-value> [-e VAR3=<my-value> [...]]]] umurmur:0.1
    ```
    Supported umurmur settings (and default values):
    
        - LISTEN4 ("" listen on any IP v4 interface)
        - LISTEN6 ("" listen on any IP v6 interface)
        - PASSWORD ("" no password)
        - ADMIN_PASSWORD ("" no admin access)
        - MAX_USERS (10)
        - SHOW_IPS (true)
        - ENABLE_BAN (true)
        - SYNC_BAN (true)
        - BAN_SECONDS (0)
        - MAX_BANDWIDTH (48000)
        - OPUS_THRESHOLD (100)
        - MOTD "Welcome to umurmur server$(hostname -f)!"
        - ALLOW_TEXT (true)
        - LOGGING (false)

    + You can also change user and group id for the user running umurmur
    ```sh
    docker run -ti -p 64738:64738 -p 64738:64738/udp -e UMURMUR_UID=500 -e UMURMUR_GUID=1000 umurmur:0.1
    ```

    + Provide your own let's encrypt certificate files
    ```sh
    docker run -ti -p 64738:64738 -p 64738:64738/udp -v <your-certificates-folder>:/etc/umurmur/cert umurmur:0.1
    ```
    The present umurmur configuration will look for files named fullchain.pem and privkey.pem (based on let's encrypt certificate files)

    + Expose logs folder if you enable logging
    ```sh
    docker run -ti -p 64738:64738 -p 64738:64738/udp -e LOGGING=true -v <your-logs-dir-on-host>:/var/log umurmur:0.1
    ```

## Contributing

1. Fork it
2. Create your feature branch: `git checkout -b feature/my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/my-new-feature`
5. Submit a pull request

## Requirements / Dependencies

* docker

## Version

0.1

## License

[MIT](LICENSE)
