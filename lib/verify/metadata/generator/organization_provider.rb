module Verify
  module Metadata
    module Generator
      class OrganizationProvider
        def provide(values)
          return nil unless values.is_a? Hash
          Organization.new(values["name"], values["display_name"], values["url"])
        end
      end
    end
  end
end
