Docker
===================

We use Docker to simplify the development of WPWatcher.
This documentation will show you how to install and use Docker to run WPWatcher.

Installation
-----------------------

#. Clone the WPWatcher repository to your local machine:

   .. code:: bash

      git clone tristanlatr/WPWatcher

#. Navigate to the cloned repository:

   .. code:: bash

      cd WPWatcher

#. Build the Docker image using the following command:

   .. code:: bash

      docker image build -t wpwatcher .

#. Create a Docker volume (to manage storage across containers):

   .. code:: bash

      docker volume create wpwatcher_data

Create the configuration file
-----------------------------

WPWatcher requires a configuration file stored in the Docker volume
created earlier. You will need to generate a template and add it to the volume.

#. Generate a template configuration file on your host machine:

   .. code:: bash

      docker run --rm --entrypoint "wpwatcher" wpwatcher --template_conf > wpwatcher.conf

#. Edit the configuration file with your preferred text editor:

   .. code:: bash

      vim wpwatcher.conf

#. Copy the configuration file to the Docker volume:

   .. code:: bash

      docker run -v "$(pwd)":/host_directory -v wpwatcher_data:/wpwatcher_data --entrypoint "cp" --user=root wpwatcher /host_directory/wpwatcher.conf /wpwatcher_data/wpwatcher.conf

Create an alias
----------------------------

To simplify the docker commands when accessing the WPWatcher app or shell, we add a permanent alias to our terminal.

* Append it to your ~/.bashrc profile:

   .. code:: bash

      echo "alias wpwatcher=\"docker run -it --entrypoint wpwatcher -v 'wpwatcher_data:/wpwatcher/.wpwatcher'\"; alias wpwatcher-shell=\"docker run -it -v \$(pwd):/wpwatcher wpwatcher\"" >> ~/.bashrc && source ~/.bashrc


* Append it to your ~/.zshrc profile:

   .. code:: bash

      echo "alias wpwatcher=\"docker run -it --entrypoint wpwatcher -v 'wpwatcher_data:/wpwatcher/.wpwatcher'\"; alias wpwatcher-shell=\"docker run -it -v \$(pwd):/wpwatcher wpwatcher\"" >> ~/.zshrc && source ~/.zshrc


Run WPWatcher container
-----------------------

Once you've created an alias, you can run WPWatcher using the ``wpwatcher [--flag]`` command. For
example, to run WPWatcher with the ``--help`` flag, run the following command:

.. code:: bash

   wpwatcher --help

Run WPWatcher repo shell
-----------------------

Since you created an alias above, you can access the shell for the repo with the following command:

.. code:: bash
   wpwatcher-shell
