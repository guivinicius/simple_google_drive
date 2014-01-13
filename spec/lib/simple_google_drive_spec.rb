require 'spec_helper'

describe SimpleGoogleDrive do

  let(:oauth2_access_token) { "1/fFBGRNJru1FQd44AzqT3Zg" }
  let(:headers) { {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>"Bearer #{oauth2_access_token}", 'Host'=>'www.googleapis.com', 'User-Agent'=>'Ruby/SimpleGoogleDrive/0.0.1'} }

  it "returns a new instance" do
    expect(SimpleGoogleDrive.new(oauth2_access_token)).to be_instance_of(SimpleGoogleDrive)
  end

  describe  "API METHODS" do

    let(:client) { SimpleGoogleDrive.new(oauth2_access_token) }

    describe "#about" do

      it "returns the user information" do
        stub_request(:get, "#{SimpleGoogleDrive::API_BASE_URL}/about").with(:headers => headers).to_return(:status => 200, :body => '{"kind": "drive#about"}')
        expect(client.about).to eq(JSON.parse('{"kind": "drive#about"}'))
      end

    end

    describe "#files" do

      let(:file_id) { 159 }

      describe "#get" do
        it "returns a file's metadata by ID" do
          stub_request(:get, "#{SimpleGoogleDrive::API_BASE_URL}/files/#{file_id}").with(:headers => headers).to_return(:status => 200, :body => '{"kind": "drive#files"}')

          expect(client.files_get(file_id)).to eq(JSON.parse('{"kind": "drive#files"}'))
        end

        it "returns a file's metadata by ID with updateViewedDate param" do
          stub_request(:get, "#{SimpleGoogleDrive::API_BASE_URL}/files/#{file_id}").with(:query => {"updateViewedDate" => "true"}, :headers => headers).to_return(:status => 200, :body => '{"kind": "drive#files"}')

          expect(client.files_get(file_id, :updateViewedDate => true)).to eq(JSON.parse('{"kind": "drive#files"}'))
        end

      end

      describe "#insert" do

        it "Insert a new file and return it's metadata." do

          request_body = '{"title":"New file from insert","description":"Blank file!"}'
          response_body = '{"kind": "drive#files", "title": "New file from insert", "description": "Blank file!"}'

          body = {:title => "New file from insert", :description => "Blank file!"}
          params = { :convert => "true" }

           stub_request(:post, "#{SimpleGoogleDrive::API_BASE_URL}/files")
           .with(:query => params, :body => request_body, :headers => headers)
           .to_return(:status => 200, :body => response_body)

          expect(client.files_insert(body, params)).to eq(JSON.parse(response_body))

        end

      end

      describe "#upload" do

        let (:file_path) { File.expand_path("spec/support/box.png") }
        let (:file_obj)   { File.open(file_path) }

        it "Upload a new file and return it's metadata using 'simple' method" do

          response_body = '{"kind": "drive#files", "title": "box.png"}'
          params = { :uploadType => "media", :convert => "true" }

           # stub_request(:post, "#{SimpleGoogleDrive::API_UPLOAD_URL}/files")
           # .with(:query => params, :body => request_body, :headers => headers)
           # .to_return(:status => 200, :body => response_body)

          expect(client.files_upload(file_obj, params)).to eq(JSON.parse(response_body))

        end

      end

      describe "#patch" do

        it "Updates file metadata and return it" do
          response_body = '{"kind": "drive#files", "title": "new title"}'

          stub_request(:patch, "#{SimpleGoogleDrive::API_BASE_URL}/files/#{file_id}").with(:body => {:title => 'new title'}, :headers => headers)
          .to_return(:status => 200, :body => response_body)

          expect(client.files_patch(file_id, {:title => 'new title'})).to eq(JSON.parse(response_body))
        end

      end

      describe "#update" do

      end

      describe "#copy" do
        it "Copies the origin file and return the copy metadata" do

          response_body = '{"kind": "drive#files"}'

          stub_request(:post, "#{SimpleGoogleDrive::API_BASE_URL}/files/#{file_id}/copy").with(:headers => headers)
          .to_return(:status => 200, :body => response_body)

          expect(client.files_copy(file_id)).to eq(JSON.parse(response_body))
        end
      end

      describe "#delete" do
        it "Permanently deletes a file by ID." do

          stub_request(:delete, "#{SimpleGoogleDrive::API_BASE_URL}/files/#{file_id}").with(:headers => headers)
          .to_return(:status => 204)

          expect(client.files_delete(file_id)).to eq("")
        end
      end

      describe "#list" do

        it "Lists the user's files" do

          response_body = '{"kind": "drive#fileList", "items":"[]"}'

          stub_request(:get, "#{SimpleGoogleDrive::API_BASE_URL}/files").with(:headers => headers)
          .to_return(:status => 200, :body => response_body)

          expect(client.files_list).to eq(JSON.parse(response_body))
        end

      end

      describe "#touch" do

        it "Set the file's updated time to the current server time." do

          response_body = '{"kind": "drive#files"}'

          stub_request(:post, "#{SimpleGoogleDrive::API_BASE_URL}/files/#{file_id}/touch").with(:headers => headers)
          .to_return(:status => 200, :body => response_body)

          expect(client.files_touch(file_id)).to eq(JSON.parse(response_body))
        end

      end

      describe "#trash" do

        it "Moves a file to the trash and return files metadata." do

          response_body = '{"kind": "drive#files"}'

          stub_request(:post, "#{SimpleGoogleDrive::API_BASE_URL}/files/#{file_id}/trash").with(:headers => headers)
          .to_return(:status => 200, :body => response_body)

          expect(client.files_trash(file_id)).to eq(JSON.parse(response_body))
        end

      end

      describe "#untrash" do
        it "Restores a file from the trash and return file metadata." do

          response_body = '{"kind": "drive#files"}'

          stub_request(:post, "#{SimpleGoogleDrive::API_BASE_URL}/files/#{file_id}/untrash").with(:headers => headers)
          .to_return(:status => 200, :body => response_body)

          expect(client.files_untrash(file_id)).to eq(JSON.parse(response_body))
        end
      end

      describe "#watch" do
        it "Start watching for changes to a file and return a api#channel metadata." do

          response_body = '{"kind": "api#channel"}'
          request_body = '{"id":"1","token":"123123","type":"web_hook","address":"192.168.0.1","params":{"ttl":"60000"}}'
          params = { :id => "1", :token => "123123",  :type => "web_hook", :address => "192.168.0.1", :params => {:ttl => "60000"} }

          stub_request(:post, "#{SimpleGoogleDrive::API_BASE_URL}/files/#{file_id}/watch").with(:body => request_body, :headers => headers)
          .to_return(:status => 200, :body => response_body)

          expect(client.files_watch(file_id, params)).to eq(JSON.parse(response_body))
        end
      end


    end

  end

end