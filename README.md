
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

```ruby
 oauth2_access_token = "YOUR ACCESS TOKEN"
 client = SimpleGoogleDrive.new(oauth2_access_token)
 client.about
```

## Methods

Each method name was made to be compliant with Google Drive API reference.

https://developers.google.com/drive/v2/reference/

### About

```ruby
    client.about
    # => {"kind": "drive#about", ... }
```

### Files methods  

* **FILES_GET** (https://developers.google.com/drive/v2/reference/files/get)

```ruby
 optional_params = {:updateViewedDate => true}
 client.files_get(file_id, optional_params)
```

* **FILES_INSERT** (https://developers.google.com/drive/v2/reference/files/insert)

This method is only for metadata-only requests not to upload files.

```ruby
 body = {:title => "A thesis about how awesome I am", :description => "No need!", }
 optional_params = { :convert => true, :ocr => true }
 client.files_insert(body, optional_params)
```

* **FILES_UPLOAD** (https://developers.google.com/drive/manage-uploads)

Supporting only: **simple** and **multipart** uploads for now.

**Simple Upload Example**

```ruby
 file_object = File.open("/tmp/awesome.pdf")
 args = {:uploadType => 'media'}
 client.files_upload(file_object, args)
```

**Multipart Upload Example**

```ruby
 file_object = File.open("/tmp/awesome.pdf")
 args = {:uploadType => 'multipart', :body_object => {:title => "A thesis about how awesome I am", :description => "Ok! It needs!" }}
 client.files_upload(file_object, args)
```

* **FILES_PATCH** (https://developers.google.com/drive/v2/reference/files/patch)

```ruby
 body = {:title => "A thesis about how awesome I am", :description => "Ok! It needs!" }
 optional_params = { :convert => true, :ocr => true }
 client.files_patch(file_id, body, optional_params)
```

* **FILES_COPY** (https://developers.google.com/drive/v2/reference/files/copy)

```ruby
 body = {:title => "A thesis about how awesome I am (copy)", :description => "Ok! It needs!" }
 optional_params = { :convert => true, :ocr => true }
 client.files_copy(file_id, body, optional_params)
```

* **FILES_DELETE** (https://developers.google.com/drive/v2/reference/files/delete)

```ruby 
 client.files_delete(file_id)
```

* **FILES_LIST** (https://developers.google.com/drive/v2/reference/files/list)

The most important part of this method is the search parameters and you can find more at https://developers.google.com/drive/search-parameters

```ruby
 optional_params = {:maxResults => 10, :q => "title = 'awesome'"}
 client.files_list(optional_params)
```

* **FILES_TOUCH** (https://developers.google.com/drive/v2/reference/files/touch)

```ruby
 client.files_touch(file_id)
```

* **FILES_TRASH** (https://developers.google.com/drive/v2/reference/files/trash)

```ruby
 client.files_trash(file_id)
```

* **FILES_UNTRASH** (https://developers.google.com/drive/v2/reference/files/untrash)

```ruby
 client.files_untrash(file_id)
```

* **FILES_WATCH** (https://developers.google.com/drive/v2/reference/files/watch)

```ruby
 client.files_watch(file_id)
```

## Todo's

* Implement authenticantion flow
* Implementing more methods
* Improve test suite

## Contributing

1. Fork it ( http://github.com/guivinicius/simple_google_drive/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
