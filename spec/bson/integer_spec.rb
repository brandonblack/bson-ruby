# encoding: utf-8
require "spec_helper"

describe Integer do

  describe "#to_bson" do

    context "when the integer is 32 bit" do

      let(:type) { 16.chr }
      let(:obj)  { Integer::MAX_32BIT - 1 }
      let(:bson) { [ obj ].pack(BSON::Int32::PACK) }

      it_behaves_like "a serializable bson element"
    end

    context "when the integer is 64 bit" do

      let(:type) { 18.chr }
      let(:obj)  { Integer::MAX_64BIT - 1 }
      let(:bson) { [ obj ].pack(BSON::Int64::PACK) }

      it_behaves_like "a serializable bson element"
    end

    context "when the integer is too large" do

      let(:integer) { Integer::MAX_64BIT + 1 }

      it "raises an out of range error" do
        expect {
          integer.to_bson
        }.to raise_error(RangeError)
      end
    end

    context "when the intger is too small" do

      let(:integer) { Integer::MIN_64BIT - 1 }

      it "raises an out of range error" do
        expect {
          integer.to_bson
        }.to raise_error(RangeError)
      end
    end
  end

  describe "#to_bson_key" do

    let(:obj)  { Integer::MAX_32BIT - 1 }
    let(:encoded) { obj.to_s + BSON::NULL_BYTE }
    let(:previous_content) { 'previous_content'.force_encoding(BSON::BINARY) }

    it "returns the encoded string" do
      expect(obj.to_bson_key).to eq(encoded)
    end

    it "appends to optional previous content" do
      expect(obj.to_bson_key(previous_content)).to eq(previous_content << encoded)
    end
  end
end
