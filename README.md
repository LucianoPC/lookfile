# Lookfile [![Build Status](https://travis-ci.org/LucianoPC/lookfile.svg?branch=master)](https://travis-ci.org/LucianoPC/lookfile) [![Code Climate](https://codeclimate.com/github/LucianoPC/lookfile/badges/gpa.svg)](https://codeclimate.com/github/LucianoPC/lookfile) [![Coverage Status](https://coveralls.io/repos/github/LucianoPC/lookfile/badge.svg?branch=master)](https://coveralls.io/github/LucianoPC/lookfile?branch=master) [![Gem Version](https://badge.fury.io/rb/lookfile.svg)](https://badge.fury.io/rb/lookfile)

Version files usage on day-to-day can be cansative and exaustive, mainly
because that files are on diferent folders, and group there it's a hard
work, therefore, the people does not can version that file. With this gem
it's can change, because this gem can group all files that you need in
a repository, and version all these files with a single command.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lookfile'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lookfile

## Usage

    lookfile [option]

    [options]

    init       $ lookfile init
               - Initialize lookfile configurations

    add        $ lookfile add [file 0] [file 1] ... [file n]
               - Add files to lookfile

    push       $ lookfile push
               - Commit files on lookfile and push to repository

    status     $ lookfile status
               - Show status of files on lookfile

    show       $ lookfile show
               - Show all files that are on lookfile

    setrepo    $ lookfile setrepo [repository_ssh]
               - Set lookfile repository to save files
               - repository_ssh: link ssh to  repository


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/[USERNAME]/lookfile. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org)
code of conduct.
