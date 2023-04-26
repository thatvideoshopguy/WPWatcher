# Docker Installation

The Docker image offers a convenient way to run WPWatcher without installing Ruby and its dependencies on your host machine. It also makes managing persistent storage easier using Docker volumes.

## Clone the repository

Clone the WPWatcher repository to your local machine:

```bash
git clone tristanlatr/WPWatcher
```

Then, navigate to the cloned repository:

```bash
cd WPWatcher
```

## Build the Docker image

Build the Docker image using the following command:

```bash
docker image build -t wpwatcher .
```

## Setup the Docker volume

Create a Docker volume named `wpwatcher_data` to manage persistent storage across containers:

```bash
docker volume create wpwatcher_data
```

## Create the configuration file

WPWatcher requires a configuration file stored in the Docker volume created earlier.

First, generate a template configuration file on your host machine:

```bash
docker run --rm --entrypoint "wpwatcher" wpwatcher --template_conf > wpwatcher.conf
```

Next, edit the configuration file with your preferred text editor and save your changes, for example vim:

```bash
vim wpwatcher.conf
```

Finally, copy the configuration file to the Docker volume:

```bash
docker run -v "$(pwd)":/host_directory -v wpwatcher_data:/wpwatcher_data --entrypoint "cp" --user=root wpwatcher /host_directory/wpwatcher.conf /wpwatcher_data/wpwatcher.conf
```

## Create an alias for easy use

Add an alias to simplify running WPWatcher with the correct volume mapping attached. To make the alias permanent, append it to your ~/.bashrc:

```bash
echo "alias wpwatcher=\"docker run -it -v 'wpwatcher_data:/wpwatcher/.wpwatcher/' wpwatcher\"" >> ~/.bashrc && source ~/.bashrc
```

Or you can append it to ~/.zshrc:

```bash
echo "alias wpwatcher=\"docker run -it -v 'wpwatcher_data:/wpwatcher/.wpwatcher/' wpwatcher\"" >> ~/.zshrc && source ~/.zshrc
```

Now you're all set to use WPWatcher with Docker!

## Run WPWatcher container

Now you can run WPWatcher, using the `wpwatcher --flag` command. For example, to run WPWatcher with the `--help` flag, run the following command:

```bash
wpwatcher --help
```
