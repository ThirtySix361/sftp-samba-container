<div align="center">

[![version](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/ThirtySix361/sftp-samba-container/master/src/version.json?&style=for-the-badge&logo=wikidata)](https://github.com/ThirtySix361/sftp-samba-container)
[![mail](https://img.shields.io/badge/contact-dev%4036ip.de-blue?style=for-the-badge&&logo=maildotru)](mailto:dev@36ip.de)
[![discord](https://img.shields.io/badge/discord-.thirtysix-5865F2?style=for-the-badge&logo=discord)](https://discord.com/users/323043165021929482)

</div>

# SFTP & SAMBA Container

<div align="center">

A docker container - used to provide an SMB and SFTP access to the same mounted volume.

[![features](https://raw.githubusercontent.com/ThirtySix361/sftp-samba-container/master/doc/features.png)](https://github.com/ThirtySix361/sftp-samba-container/)

</div>

## 🌐 links

[source code](https://github.com/ThirtySix361/sftp-samba-container)

## 🔗 dependencies

docker

## 🚀 quick start

step 1.

```bash
git clone https://github.com/ThirtySix361/sftp-samba-container
cd sftp-samba-container
```

step 2.

```bash
bash build.sh
```

step 3.

```bash
bash run.sh
```
will deploy the container with default ``SFTP port 22`` and default ``SAMBA port 445``<br>
the default mount point will be ``$basedir/mnt/``<br>
the default share name will be ``nas``<br>
the default user will be ``user``<br>
the default password will be ``pass``<br>

it is recommended to specify those variables on the ``run.sh`` command
```bash
bash run.sh "122 1445" "$(pwd)/mnt/" "data" "customuser1:custompassword2"
```
this example will deploy the container with custom ``SFTP port 122`` and custom ``SAMBA port 1445``<br>
the custom mount point by will be ``sftp-samba-container/mnt/``<br>
the custom share name will be ``data``<br>
the custom user will be ``customuser1``<br>
the custom password will be ``custompassword2``<br>
