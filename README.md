Prototype of convertion kit from asciidoc to PDF
-----

# Prerequisites

***NB:*** if you already installed WSL2 and Podman, go to section [Edit `*.adoc` files with VS Code](#edit-adoc-files-with-vs-code)

## Install WSL

- type the command below in a **Pwershell as administrator** :

```
wsl --install
```
> if you run on a old Windows version, you need to do a manual installation (See [Official doc](https://learn.microsoft.com/fr-fr/windows/wsl/install-manual))

- Go on the Microsoft Store and install **Ubuntu-22.04.2 LTS** from **Canonical Group Limited**

- Once installed, start the app **Ubuntu 22.04.2 LTS**

- In the terminal which has just opened, configure yout ubuntu session

## Install podman

*podman is an open-source alternative to docker that doesn't need the root access to run*

- Still in the Ubuntu terminal, update the installation with the following commands :

```
sudo apt update
sudo apt upgrade
```

- install podman :

```
sudo apt install podman
```

>**PS:** To install a more recent version of Podman, see the [official documentation](https://podman.io/docs/installation#debian)

## Install podman-compose

> podman-compose is not used in this kit

*podman-compose is an open-source alternative to docker-compose written in python*

- install python3 and pip3 :

```
sudo apt install python3
sudo apt install python3-pip
```

- install podman-compose :

```
pip3 install podman-compose
```

# Edit `*.adoc` files with VS Code

In order to avoid going through the kroki public server and sending potentially confidential diagrams externally,
you need to start a server locally with podman:

## Start Kroki locally

type the following command in an Ubuntu terminal :

```
podman run -d --rm -p='8000:8000' docker.io/yuzutech/kroki
```
> **-d** for *detached* from terminal, run the server in the back \
> **--rm** deletes the container created from the image when it is stopped \
> **-p='8000:8000'** map port 8000 of the host to port 8000 of the container

to see the container information, type the following command :

```
podman container list
```

to stop the container, type the following command after retrieving the ID with the previous command :

```
podman container stop <CONTAINER ID>
```

to verify that the container is working correctly,
type the address [http://localhost:8000/](http://localhost:8000/) into a web browser on your machine

# Convert to PDF

## Kit composition

the kit contains the file tree below :

```
asciidoctor-2-pdf-kit/
├── asciidoc-demo/
│   ├── bug-feature.png
│   ├── counter.v
│   ├── README.adoc
│   └── myTable.csv
├── image/
│   ├── resources/
│   │   ├── fonts/
│   │   ├── themes/
│   │   └── entrypoint.sh
│   └── Dockerfile
├── template.adoc
└── README.md (this file)
```

## Detail of important files

- **asciidoctor-2-pdf.tar** : the image which contains all the executables, fonts, logo and theme for conversion to PDF.
- **template.adoc** : a template to start an AsciiDoc documentation.

## Compile image

type the following command in a terminal at the location of this `README.md` :

```
podman build -t asciidoctor-2-pdf:latest -f ./image/Dockerfile
```

Type the `podman image list` command to verify that the image has been compiled and added to the localhost directory.

## Start the conversion

**Prerequisites: *have launched the kroki server***,
see section [Start Kroki locally](#start-kroki-locally)

- in an Ubuntu terminal, type following command :

```
podman run --rm -v=<path_to_adoc_file>:/documents/:rw --network='host' localhost/asciidoctor-2-pdf:latest <your_file.adoc>
```
> **<path_to_adoc_file>** can be a path relative to the location of execution of this command. \
> **<your_file.adoc>** if the file to convert is called `README.adoc` this parameter can be ignored.

- if no error is displayed in the terminal,
The resulting PDF file is located in the `build` folder and is named according to the generation date and time.

# Example

after launching kroki (see section [Start Kroki locally](#start-kroki-locally))

place yourself in the folder of this `README.md` and type the following command :

```
podman run --rm -v=./asciidoc-demo/:/documents/:rw --network='host' localhost/asciidoctor-2-pdf:latest
```

A `build` folder should appear in the `asciidoc-demo` folder and contain the demonstration file in PDF format.

# Good practices

- Use the template provided to start an asciidoc document.

- go read the best practices asciidoc : \
  https://asciidoctor.org/docs/asciidoc-recommended-practices/

- always give a title to tables/images or figures : \
  https://docs.asciidoctor.org/asciidoc/latest/tables/add-title/

- If you have any questions, see the official documentation : \
  https://docs.asciidoctor.org/

# troubleshooting

## ERRO[0000]

`ERRO[0000] error loading cached network config: network "podman" not found in CNI cache`

- Type the command :

```
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
```
> this is a workaround, this problem appears in podman v3.4.4 on WSL2 with Ubuntu 22.04 \
> original link [ici](https://sites.google.com/site/pawneecity/docker/podman-docker#h.thndndbwddlk)

## apt update

if `sudo apt update` command does not work in WSL2, you can :

- restart WSL by typing the following command in a **Powershell**:

```
wsl --shutdown
```

- clear the contents of this folder in Ubuntu :

```
sudo rm -r /var/lib/apt/lists/
```

# Use VS Code

very practical for editing documents with real-time rendering.

Download VS Code [**HERE**](https://code.visualstudio.com/download) and install it on your windows session.

## The essential extensions

to render locally in VS Code, download the extensions :
- [**WSL**](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) from **Microsoft**
- [**AsciiDoc**](https://marketplace.visualstudio.com/items?itemName=asciidoctor.asciidoctor-vscode) from **asciidoctor**

## Start WSL

- in a new VS Code window, press the keys `ctrl + shift + p`

- in the text bar that opens, type the command `>WSL: New WSL Windows using Distro...` and select `Ubuntu-22.04`

- select `Open folder` and navigate until you find the right folder.

PS: remember to make a git clone of the project beforehand in WSL to be able to open the file.

## Configure asciidoctor

- in the VS Code window open in WSL, press the keys `ctrl + shift + p`

- type the command `>Preferences: Open User Settings (JSON)` because the option to modify is not accessible through the settings UI

- add the following lines to the `settings.json` file which opened :

```json
{
    "asciidoc.extensions.enableKroki": true,
    "asciidoc.preview.asciidoctorAttributes": {"kroki-server-url":"http://localhost:8000/"},
}
```
**NB :** you must activate the kroki server for rendering to work, see section [Start Kroki locally](#start-kroki-locally) \

**NB2: To perform the step below, you need a `*.adoc` file open in the editor and in the foreground for the option to be accessible.**

Press the `Ctrl + Shift + p` keys and type the command `>AsciiDoc: Manage Preview Security Settings`, \
then select `Allow insecure local content`.

This is necessary because the local Kroki server is in HTTP.

You can now preview AsciiDoc files in VS Code.
