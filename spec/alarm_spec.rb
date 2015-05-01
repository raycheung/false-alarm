require 'spec_helper'

describe Alarm do
  describe '#name' do
    context 'if tag present' do
      before { subject.tag = "a_tag" }
      specify { expect(subject.name).to eq "a_tag" }
    end

    context 'if no tag' do
      before do
        subject.key = "00172a8"
        subject.tag = nil
      end

      specify { expect(subject.name).to eq "00172a8" }
    end
  end
end
