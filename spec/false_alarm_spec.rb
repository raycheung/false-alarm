require 'spec_helper'

describe FalseAlarm do
  include Rack::Test::Methods

  describe "/new/:interval" do
    context "for valid intervals" do
      Alarm::INTERVALS.each do |interval|
        it "gets a new hash key with interval: #{interval}" do
          get "/new/#{interval}"
          expect(last_response).to be_ok
          last_one = Alarm.last
          expect(last_one.key).to match Alarm::KEY_FORMAT
          expect(last_one.interval).to eq interval
        end
      end
    end

    context "for an invalid interval" do
      it "returns 404" do
        get "/new/secondly"
        expect(last_response).not_to be_ok
        expect(last_response.status).to eq 404
        expect(last_response.body).to match /interval/
      end
    end
  end

  describe "/:key" do
    let(:key) { "12345ab" }
    before { Alarm.create!(key: key, interval: "daily", last_call: nil, total: 0) }

    it "updates the :last_call field" do
      get "/#{key}"
      expect(last_response).to be_ok
      expect(last_response.body).to match /OK/
      last_one = Alarm.last
      expect(last_one.last_call).to be_present
      expect(last_one.last_call).to be_a DateTime
    end

    it "increase total by 1" do
      get "/#{key}"
      expect(last_response).to be_ok
      last_one = Alarm.last
      expect(last_one.total).to eq 1
    end

    context "if :key is not in valid format" do
      let(:bad_key) { "zzzzz" }

      before { expect(bad_key).not_to match Alarm::KEY_FORMAT }

      it "doesn't hit the database" do
        expect(Alarm).not_to receive(:find_by)
        get "/#{bad_key}"
        expect(last_response).not_to be_ok
        expect(last_response.status).to eq 404
      end
    end

    context "if fails to persist" do
      it "raises an error" do
        expect_any_instance_of(Alarm).to receive(:save).and_return(false)
        expect { get "/#{key}" }.to raise_error("failed to persist")
      end
    end
  end
end
