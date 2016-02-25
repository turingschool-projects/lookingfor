## Description
LookingFor is a rails application that pull developer job postings from the internet and uses them to answer the question 'Hello, is it me you're looking for?'

[Visit the App in Production](https://lookingforme.herokuapp.com/)

## Documentation
We use [basecamp](https://3.basecamp.com/3278136/projects/495148) to keep track of project information, wireframes, etc. Contact the team to be added to the project.

We track upcoming work in Github Issues.

## Local Setup

Backend:

- Ruby
- PostgreSQL
- Puma Server

To install Ruby, check out [RVM](https://rvm.io), [rbenv](https://github.com/sstephenson/rbenv) or [ruby-install](https://github.com/postmodern/ruby-install).

PostgreSQL can be installed with [Homebrew](http://brew.sh) on Mac OS X: `brew install postgresql`
If you're on a Linux system with apt-get then run: `apt-get install postgresql postgresql-contrib`

* You will need to make sure postgres is running and then run these commands in console:
  - `bundle install` - Install all dependencies
  - `rake db:create` - Create the database
  - `rake db:migrate` - Migrate the database
  - `rake db:seed` - Seed the database

* You can import a semi-current copy of the production database
  - Drop your local db: `rake db:drop`
  - Assuming you haven't changed any of the basic defaults - run `heroku pg:pull DATABASE_URL lookingfor_development --app lookingforme`
  - [Find out more here](https://devcenter.heroku.com/articles/heroku-postgresql#pg-push-and-pg-pull)

### Run The Application

* Start the server with: `bundle exec rails s`
* Then you can access the local server at [localhost:3000](http://localhost:3000)

### Testing
1. Run the test suite: `bundle exec rspec`

To run a single test suite, you can do so with:

```bash
  rspec path/to/the_spec.rb
```
To run a single test, you can do so by running the its first line:

```bash
  rspec path/to/the_spec.rb:15
```

### Workflow

1. Fork and clone.
1. Add the upstream lookingfor repository as a new remote to your clone.
   `git remote add upstream https://github.com/LookingForMe/lookingfor.git`
1. Create a new branch
   `git checkout -b name-of-branch`
1. Commit and push as usual on your branch.
1. When you're ready to submit a pull request, rebase your branch onto
   the upstream master so that you can resolve any conflicts:
   `git fetch upstream && git rebase upstream/master`
   You may need to push with `--force` up to your branch after resolving conflicts.
1. When you've got everything solved, push up to your branch and send the pull request as usual.

### Application Monitoring

LookingFor uses [New Relic](http://newrelic.com/).

In order to access the account for LookingFor, you will need to ask one of the maintainers to invite you via e-mail. New Relic is already set up with Heroku, so this is all you need to access the production data.

If you want to run New Relic locally, you will also need the New Relic license key.

Once you have the license key and access to the account, you'll need to set up figaro:

1. Generate an application.yml file by typing in your terminal:

  `$ bundle exec figaro install`

2. Add the following line to your application.yml file:

 `new_relic_license_key: <key provided>`

3. Restart your server and the data will show up on New Relic within a few minutes.
