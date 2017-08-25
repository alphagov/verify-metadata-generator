require 'verify/metadata/generator/entity_descriptor_validator'
module Verify
  module Metadata
    module Generator
      describe EntityDescriptorValidator do
        context "#validate will try and validate the provided entity descriptors" do
          let(:validator){EntityDescriptorValidator.new}
          it "will do nothing if the descriptor is valid" do 
            descriptor = double("descriptor")
            descriptors = [descriptor]
            expect(descriptor).to receive(:invalid?).and_return false
            expect{validator.validate(descriptors)}.to_not raise_error
          end
          it "will raise if there are errors" do 
            descriptor = double("descriptor", :id => "ID")
            descriptors = [descriptor]
            expect(descriptor).to receive(:invalid?).and_return true
            expect(descriptor).to receive(:error_messages).and_return ["ERROR MESSAGE"]
            expected_message = "ID had the following errors:\n  * ERROR MESSAGE"
            expect{validator.validate(descriptors)}.to raise_error InputValidationError, expected_message
          end
        end
      end
    end
  end
end
