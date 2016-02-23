## Description
LookingFor is a rails application that pull developer job postings from the internet and uses them to answer the question 'Hello, is it me you're looking for?'

[Visit the App in Production](https://lookingforme.herokuapp.com/)

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
