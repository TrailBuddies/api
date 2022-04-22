<div align="center">
  
  <img src="https://i.ibb.co/L5pYP25/logo.png" alt="trailbuddies logo" width="124" />
  
  ## TrailBuddies (api)
  
  https://trailbuddies.club
  
  Find friends to hike with!
  
  <sub>

  ⚠️ This project is under development. If you want to help please read [this](https://trailbuddies.club/join) ⚠️

  </sub>
  
</div>

---

## Setup
### Primary Dependencies
| Tool | Version | Help |
| :-- | :-- | :-: |
| Ruby on Rails | `Rails 7.0.1` | [Installation guide](https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails) |
| RBEnv | `rbenv 1.2.0` | [Installation guide](https://github.com/rbenv/rbenv#installation) |
| Ruby | `ruby 3.1.0p0 (2021-12-25 revision fb4df44d16)` | Install via RBEnv |
| PostgreSQL | `postgres (PostgreSQL) 13.4` | [Installation guide](https://www.postgresql.org/download/) |
| TomTom API | `1` | n/a |
| Cloudinary API | `n/a` | n/a |

### Secondary (Ruby) Dependencies
❗ These are all defined in `Gemfile`
| Package | Version | Help | Reason |
| :-- | :-: | :-: | :-- |
| [`net-smtp`](https://rubygems.org/gems/net-smtp) | `'~> 0.3.1'` | [Github repo](https://github.com/ruby/net-smtp) | 🤷 |
| [`rails`](https://rubygems.org/gems/rails) | `'~> 7.0.1', '>= 7.0.0'` | [Rails Guides](https://guides.rubyonrails.org/) | pretty obvious, right? |
| [`pg`](https://rubygems.org/gems/pg) | `'~> 1.1'` | [Docs](https://deveiate.org/code/pg/) | Allows PostgreSQL Active Record intergration |
| [`puma`](https://rubygems.org/gems/puma) | `'~> 5.0'` | [Docs](https://puma.io/puma/) | 🤷 |
| [`bcrypt`](https://rubygems.org/gems/bcrypt) | `'~> 3.1.7'` | [Github repo](https://github.com/bcrypt-ruby/bcrypt-ruby) | Hash and compare password digests for users |
| [`bootsnap`](https://rubygems.org/gems/bootsnap) | `'>= 1.4.4'` | [Github repo](https://github.com/Shopify/bootsnap) | 🤷 |
| [`byebug`](https://rubygems.org/gems/byebug) | `'~> 11.1.3'` | [Rubydoc](https://www.rubydoc.info/gems/byebug/11.1.3) | 🤷 |
| [`listen`](https://rubygems.org/gems/listen) | `'~> 3.3'` | [Rubydoc](https://www.rubydoc.info/gems/listen/3.3.0) | 🤷 |
| [`spring`](https://rubygems.org/gems/spring) | `'~> 4.0.0'` | [Rubydoc](https://www.rubydoc.info/gems/spring/4.0.0) | 🤷 |
| [`tzinfo-data`](https://rubygems.org/gems/tzinfo-data) | `'~> 1.2021.5'` | [Rubydoc](https://www.rubydoc.info/gems/tzinfo-data/1.2021.5) | 🤷 |
| [`jwt`](https://rubygems.org/gems/jwt) | `'~> 2.3'` | [Docs (github)](https://github.com/jwt/ruby-jwt/blob/master/README.md) | Create, sign, and validate Json Web Tokens |
| [`rack-cors`](https://rubygems.org/gems/rack-cors) | `'~> 1.1.1'` | [Rubydoc](https://www.rubydoc.info/gems/rack-cors/1.1.1) | Something to do with CORS I think |
| [`rmagick`](https://rubygems.org/gems/rmagick) | `'~> 4.2.4'` | [Rubydoc](https://www.rubydoc.info/gems/rmagick/4.2.4) | To edit images before storing them with Cloudinary |
| [`cloudinary`](https://rubygems.org/gems/cloudinary) | `'~> 1.22'` | [Docs](http://cloudinary.com/documentation/rails_integration) | Use Cloudinary for Active Record attachments |
| [`httparty`](https://rubygems.org/gems/httparty) | `'~> 0.20'` | [Rubydoc](https://www.rubydoc.info/gems/httparty/0.20.0) | Send HTTP requests to the TomTom API |

### Environment Variables
| Name | Description | Type | Required | Default | Example |
| :-- | :-- | :-: | :-: | :-: | :-- |
| `PASSPHRASE` | A passphrase for the RSA keypair | `string` | ❌ |  | `entail.trickily.ravioli` |
| `API_DB_USER` | PostgreSQL user that can access all necessary databases | `string` | ✔️ |  | `api_admin` |
| `API_DB_PASSWORD` | The password for the above user | `string` | ❌ |  | `D$!5wK%9dm79Y$iS` |
| `API_DB_HOST` | The PostgreSQL daemon host address | `string` | ❌ | `localhost:5432` | `db.example.app:9931` |
| `EMAIL` | An email address for the seed user (created with rails `db:seed`) | `string` | ✔️ |  | `admin@example.app` |
| `PASSWORD` | An unhashed (plain text) password for the seed user (above) | `string` | ✔️ |  | `!SF%h&F^*52FMTGe` |
| `CLOUDINARY_SECRET` | A [Cloudinary API secret](https://cloudinary.com/documentation/cloudinary_glossary#api_key_and_secret). Will be used to store images | `string` | ✔️ |  | `FiPxyRsCqusHvXjaTtDttZmt` |
| `TOMTOM_API_KEY` | A [TomTom maps](https://developer.tomtom.com/map-display-api/documentation/product-information/introduction) API key. Will be used te generate map images | `string` | ✔️ |  | `LRYbKgAuqUowhHtEoYtMNtLjPyfcNsN` |
| `RSA_PUBLIC_KEY` | A RSA public key used to decode JWTs | `string` | ❌ | Contents of `config/rsa/public.pem` | `-----BEGIN RSA PUBLIC KEY----- MIIBCgKCAQEA5v...uKxyo/NQIDAQAB -----END RSA PUBLIC KEY-----` |
| `RSA_PRIVATE_KEY` | A RSA private key used to sign JWTs | `string` | ❌ | Contents of `config/rsa/private.pem` | `-----BEGIN RSA PRIVATE KEY----- Proc-Type: 4,ENCRYPTED DEK-Info: AES-128-CBC,E01081BC91C9A106B160F08A24679562 MIIBCgKCAQEA5v...uKxyo/NQIDAQAB -----END RSA PRIVATE KEY-----` |

### Git Ignored Files
| File | Description |
| :-- | :-- |
| `config/master.key` | The Rails credentials master key |
| `config/rsa/*.pem` | The RSA keypair generated with `bin/keygen` |

### RSA Keypair
You will need to generate a private/public keypair. On linux the commands would be: (in the project root)
```bash
$ rm -rf config/rsa/*.pem
$ mkdir -p config/rsa
$ ssh-keygen -o -f config/rsa/key -N $PASSPHRASE -t rsa -b 2048 -m pem
$ mv config/rsa/key config/rsa/private.pem
$ ssh-keygen -f config/rsa/key.pub -e -m pem > config/rsa/public.pem
$ rm config/rsa/key.pub
```
❗ These commands are saved in the `bin/keygen` file
