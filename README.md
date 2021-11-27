# Trails_Buddies / **api**

##### Pre-Development
You will need to generate a private/public keypair. On linux the commands would be: (in the project root)
```bash
$ rm -rf config/rsa/*.pem
$ ssh-keygen -o -f config/rsa/key -N $PASSPHRASE -t rsa -b 2048 -m pem
$ mv config/rsa/key config/rsa/private.pem
$ mv config/rsa/key.pub config/rsa/public.pem
```

These commands are saved in the `bin/keygen` file


##### Required Environment Variables
```
# Rails rsa passphrase
export PASSPHRASE="< passphrase >"

# Rails DB config
export API_DB_USER="< user >"
export API_DB_PASSWORD="< password >"
export API_DB_HOST="< host >"

# Rails seed user config
export PASSWORD="< password >"
export EMAIL="< email >"
```

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
