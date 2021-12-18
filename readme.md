Final Project for the course BPC-BDS
====================================

[Dependencies](dependencies.html)

This application is supposed to run a program similar to the learning platform Sololearn. Mine just looks way worse and won't teach you anything.

Hmm, how do I run this App?
---------------------------

<h3>Have installed in your Linux system:</h3>
- Git
- PostgreSQL
- Java OpenJDK 11 or newer
- Maven
- Shell command `at` (Used for periodic backups)

<h3>Clone all of this beautiful mess</h3>
- `git clone https://github.com/BorekZnovustvoritel/Projekt_BDS_3.git`
- `cd projekt_BDS_3/`

<h3>Create a database and setup the connection.</h3>
- Switch user to postgres `su postgres` and complete the authentication, then type `psql`
- Create a database with `CREATE  DATABASE IF NOT EXISTS projektBDS;` and then `exit`
- Load the database with `psql projektBDS < db.sql`

<h3>Setup automatic backups</h3>
(Still as user `postgres`)
- `bash ./timed_backup.sh`
- `exit`
- `mkdir backups`
- `sudo chmod 766 backups`

<h3>Run! (Not you, the program.)</h3>
- `mvn clean install`
- `java -jar target/Projekt_BDS_3-1.0.0.jar`

<h3>Log into the app</h3>
Try username `Wankler.Karel@gmail.com` and password `batman`. Every password is `batman` btw. Just look into the db and login as whoever you want.

<h3>Admire the beautiful chaos I have created</h3>
- This step is not optional
- You must do this
