# Blip API

[![Build Status](https://travis-ci.org/rouanw/blip-api.svg?branch=master)](https://travis-ci.org/rouanw/blip-api)

API for storing your [blips](https://github.com/rouanw/blip) in the cloud.

## Contributing

Pull requests are most welcome :)

### Dependencies

- Ruby (You can check the current version in the [.ruby-version](.ruby-version) file.)
- RVM (If you want an automatically configured [gemset](.ruby-gemset).)
- Mongo DB
- Heroku toolbelt

### Environment Configuration

You'll need to create an `.env` file in the root of your project, with the following values set:

```
TWITTER_KEY=getthisfromtwitter
TWITTER_SECRET=getthisfromtwitter
GITHUB_KEY=getthisfromgithub
GITHUB_SECRET=getthisfromgithub
MONGOLAB_URI=mongodb://localhost:27017
SESSION_SECRET=somesecret
```

### Getting Started

- `bundle install` - download dependencies
- `sh mongo.sh` - start the database
- `heroku local` - run the server
