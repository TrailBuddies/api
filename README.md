# Trails_Buddies / **api**

##### Setup
| Tool | Version | Help |
| :--- | :--- | :--- |
| Ruby on Rails | `Rails 7.0.1` | [Installation guide](https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails) |
RBEnv | `rbenv 1.2.0` | [Installation guide](https://github.com/rbenv/rbenv#installation) |
Ruby | `ruby 3.1.0p0 (2021-12-25 revision fb4df44d16)` | [Downloads](https://www.ruby-lang.org/en/downloads/) |
PostgreSQL | `postgres (PostgreSQL) 13.4` | [Installation guide](https://www.postgresql.org/download/) |
TomTom API | `1` | n/a |
Cloudinary API | `n/a` | n/a |

##### Required Environment Variables
| Name | Type | Required | Example |
|
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

# Cloudinary
export CLOUDINARY_SECRET="< cloudinary api secret >"

# TomTom Maps API
export TOMTOM_API_KEY="< tomtom api key >"
```

##### Pre-Development
You will need to generate a private/public keypair. On linux the commands would be: (in the project root)
```bash
$ rm -rf config/rsa/*.pem
$ mkdir -p config/rsa
$ ssh-keygen -o -f config/rsa/key -N $PASSPHRASE -t rsa -b 2048 -m pem
$ mv config/rsa/key config/rsa/private.pem
$ ssh-keygen -f config/rsa/key.pub -e -m pem > config/rsa/public.pem
$ rm config/rsa/key.pub
```

These commands are saved in the `bin/keygen` file
