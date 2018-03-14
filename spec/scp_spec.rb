require File.expand_path('../spec_helper', __FILE__)

module Pod
  module Downloader
    describe 'SCP' do
      before do
        tmp_folder.rmtree if tmp_folder.exist?
        @fixtures_url = fixture('scp').to_s
      end

      it 'download file and unzip it over SCP (using mock)' do
        options = { :scp => "scp://localhost:#{@fixtures_url}/lib.zip" }
        downloader = Downloader.for_target(tmp_folder, options)
        downloader.expects(:execute_command).
          with('scp', ['-P', '22', '-q', "localhost:'#{@fixtures_url}/lib.zip'", tmp_folder('file.zip')], true).
          returns(nil)
        downloader.expects(:execute_command).
          with('unzip', [tmp_folder('file.zip'), '-d', tmp_folder], true).
          returns(nil)
        downloader.download
      end

      it 'should specify port, when the spec explicitly demands it (using mock)' do
        options = {
          :scp => "scp://localhost:#{@fixtures_url}/lib.zip",
          :port => 1022,
        }
        downloader = Downloader.for_target(tmp_folder, options)
        downloader.expects(:execute_command).
          with('scp', ['-P', '1022', '-q', "localhost:'#{@fixtures_url}/lib.zip'", tmp_folder('file.zip')], true).
          returns(nil)
        downloader.expects(:execute_command).
          with('unzip', [tmp_folder('file.zip'), '-d', tmp_folder], true).
          returns(nil)
        downloader.download
      end

      it 'should specify user, when the spec explicitly demands it (using mock)' do
        options = { :scp => "scp://user@localhost:#{@fixtures_url}/lib.zip" }
        downloader = Downloader.for_target(tmp_folder, options)
        downloader.expects(:execute_command).
          with('scp', ['-P', '22', '-q', "user@localhost:'#{@fixtures_url}/lib.zip'", tmp_folder('file.zip')], true).
          returns(nil)
        downloader.expects(:execute_command).
          with('unzip', [tmp_folder('file.zip'), '-d', tmp_folder], true).
          returns(nil)
        downloader.download
      end

      xit 'download file and unzip it over SCP (using scp://localhost)' do
        options = { :scp => "scp://localhost:#{@fixtures_url}/lib.zip" }
        downloader = Downloader.for_target(tmp_folder, options)
        downloader.download
        tmp_folder('lib/file.txt').should.exist
        tmp_folder('lib/file.txt').read.strip.should =~ /This is a fixture/
      end
    end
  end
end
