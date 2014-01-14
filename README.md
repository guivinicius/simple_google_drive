
# SimpleGoogleDrive

[![Build Status](https://travis-ci.org/guivinicius/simple_google_drive.png?branch=master)](https://travis-ci.org/guivinicius/simple_google_drive)
[![Code Climate](https://codeclimate.com/repos/52d5408f6956800ac6002687/badges/d52569719f4be221b7e5/gpa.png)](https://codeclimate.com/repos/52d5408f6956800ac6002687/feed)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/guivinicius/simple_google_drive/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

A simple interface for Google Drive API

## Installation

Add this line to your application's Gemfile:

    gem 'simple_google_drive'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_google_drive

## Getting Started

You need to create a new object and then call its methods. Simple like that.

    oauth2_access_token = "YOUR ACCESS TOKEN"
    client = SimpleGoogleDrive.new(oauth2_access_token)
    client.about

## Methods

Each method name was made to be compliant with Google Drive API reference.

https://developers.google.com/drive/v2/reference/

### About

    client.about

### Files

    client.files_get(file_id, parameters)
    client.files_insert(body, parameters)
    client.files_upload(file_obj, params)
    client.files_patch(file_id, body, params)
    client.files_copy(file_id, body, params)
    client.files_delete(file_id)
    client.files_list(params)
    client.files_touch(file_id)
    client.files_trash(file_id)
    client.files_untrash(file_id)
    client.files_watch(file_id, body)

## Contributing

1. Fork it ( http://github.com/guivinicius/simple_google_drive/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
