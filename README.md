# DermaBase 🏥💻

DermaBase is a powerful yet easy-to-use application designed for dermatologists and their assistants to manage patient records efficiently. The suite includes two versions:

- DermaBase (Doctor)    >> For dermatologists to diagnose, prescribe, and manage patient history.
- DermaBase (Assistant) >> For assistants to handle patient intake, and medical documentation.


## Technology Stack

- Frontend: Qt (QtQuick/QML)
- Backend: Qt, C++
- Database: MySQL


## Installation & Setup

For the easiest setup, download one of the prebuilt executables or installation packages from the Releases section. Download the latest version for your operating system (Windows, macOS, or Linux) and follow the installation instructions provided in the release notes.


## Project Setup

Before using this project and building it, ensure your development environment meets the following requirements for each OS:

### Windows

1. Install a MySQL service (preferably MySQL Workbench) and use the provided SQL files to setup the database.
2. Install and open the [Qt Online Installer](https://www.qt.io/download-qt-installer-oss) for Windows.
3. Install Qt Framework (Version 6.8 LTS) & QtCreator using the installer.
4. Clone the repository and open the CMakeLists.txt file in the Qt Creator.
5. Configure the project with your favourite compiler (preferably MSVC).
6. Build and Run the project.

### macOS

1. Install a MySQL service (preferably MySQL Workbench) and use the provided SQL files to setup the database.
2. Install and open the [Qt Online Installer](https://www.qt.io/download-qt-installer-oss) for macOS.
3. Install Qt Framework (Version 6.8 LTS) & QtCreator using the installer.
4. Clone the repository and open the CMakeLists.txt file in the Qt Creator.
5. Configure the project with your favourite compiler.
6. Build and Run the project.  

### Linux

1. Install a MySQL service (preferably MySQL Workbench) and use the provided SQL files to setup the database.
2. The project uses a MySQL database. Therefore, you may need to install additional packages to make the project work on Linux:
```diff
sudo apt install libmysqlclient-dev
```
3. Since QML uses OpenGL, on Linux systems, you may need to install additional dependencies to avoid errors:
```diff
sudo apt install libglx-dev libgl1-mesa-dev
```
4. The project uses the 'PrintSupport' module. Therefore, you may need to install the CUPS printing system module for Linux:
```diff
sudo apt-get install libcups2-dev
```
5. Install and open the [Qt Online Installer](https://www.qt.io/download-qt-installer-oss) for Linux.
6. Install Qt Framework (Version 6.8 LTS) & QtCreator using the installer.
7. Clone the repository and open the CMakeLists.txt file in the Qt Creator.
8. Configure the project with your favourite compiler.
9. Build and Run the project.


## Drivers

Whether you are trying to run the application or simply set up the project on your device, you will need drivers for the MySQL database. For legal reasons, we cannot ship these drivers directly. Therefore, you must obtain them manually from the following link:

[MySQL drivers](https://github.com/thecodemonkey86/qt_mysql_driver)


## Documentation

The following are useful links for this project:

- [Executing SQL Statements](https://doc.qt.io/qt-6.7/sql-sqlstatements.html)
- [internationalization (layout)](https://doc.qt.io/qt-6/qtquick-positioning-righttoleft.html)
- [Python Official Docs](https://docs.python.org/3/)


## Contributing

We welcome contributions! Feel free to submit issues, feature requests, or pull requests.


## License

This project is licensed under the [MIT License](LICENSE).
