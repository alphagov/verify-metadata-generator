require 'openssl'
module Verify
  module Metadata
    module Generator
      class StoreProvider
        def initialize(cert_files)
          @cert_files = cert_files
        end

        def provide
          store = OpenSSL::X509::Store.new
          @cert_files.each do |file|
            store.add_file file
          end
          store
        end
      end
    end
  end
end
