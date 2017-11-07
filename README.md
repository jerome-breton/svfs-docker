# The Swift Virtual File System in a Docker container

**SVFS** is a Virtual File System over Openstack Swift built upon fuse. It is compatible with [hubiC](https://hubic.com),
[OVH Public Cloud Storage](https://www.ovh.com/fr/cloud/storage/object-storage) and basically every endpoint using a standard
Openstack Swift setup.  It brings a layer of abstraction over object storage, making it as accessible and convenient as a
filesystem, without being intrusive on the way your data is stored.

This container is based on https://github.com/ovh/svfs/ 

## Mount HubiC drive

1. Go to https://hubic.com/home/browser/developers/
2. Create a new application, with the name you want and domain `http://localhost/`
3. Click on *details* on the created application and note client id and client secret
4. Launch `docker run -ti --rm jeromebreton/svfs hubic-application` and enter your application credentials then your account credentials
5. Write a svfs.yaml file containing hubic auth tokens :

        hubic_auth: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        hubic_token: XXXXXXXXXXXXXX

6. Launch `docker run -ti --rm --device /dev/fuse --cap-add SYS_ADMIN --privileged --volume=/local/directory/for/mount:/ovh:shared --volume=/path/to/svfs.yaml:/etc/svfs.yaml:ro jeromebreton/svfs`

### Options

You can use some env variables to change mount parameters : 

- `UID` (default: 1000)
- `GID` (default: 1000)
- `MODE` (default: 0755)
- `ARGS` to add any arg you want. Get help by running `docker run -ti --rm jeromebreton/svfs svfs mount --help`

Exemple :

    docker run -ti --rm --device /dev/fuse --cap-add SYS_ADMIN --privileged \
               --env MODE=0777 --env ARGS="--allow-other --os-connect-timeout=5m --os-segment-size=1024" 
               --volume=/path/to/svfs.yaml:/etc/svfs.yaml:ro jeromebreton/svfs

### Docker Compose

You can use docker compose instead of the docker run command : 

    version: '2'
    services:
      hubic:
        container_name: hubic
        image: jeromebreton/svfs
        restart: unless-stopped
        volumes:
          - ./svfs.yaml:/etc/svfs.yaml:ro
          - ./mount:/ovh:shared
        devices:
          - /dev/fuse
        cap_add:
          - SYS_ADMIN
        privileged: true
        environment:
          - MODE=0775


## Mount OVH Public Cloud Storage or Swift endpoint

I do not have any endpoint like this to test at the moment, but you should be able to connect one by writing a svfs.yaml containing your config :

        os_auth_url: XXXXXXXXX
        os_auth_token: XXXXXXXXX
        os_tenant_name: XXXXXXXXX
        os_username: XXXXXXXXX
        os_password: XXXXXXXXX
        os_region_name: XXXXXXXXX
        os_storage_url: XXXXXXXXX

You should find more details in the original project README : https://github.com/ovh/svfs/blob/master/README.md


