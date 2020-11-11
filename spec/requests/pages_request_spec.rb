require 'rails_helper'

RSpec.describe "Pages", type: :request do

  describe "GET /home" do
    it "returns http success" do
      get "/pages/home"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /process_order" do
    subject(:process_order) { get process_order_path, params: params }

    context "When vegemite scroll's order is present" do
      let(:params) { {'vegemite_scroll': '12'} }

      it 'returns the count of packs for vegemite scroll' do
        process_order
        
        json_body = JSON.parse(response.body)
        expect(json_body['vegemite_scroll']).not_to be_nil
      end
    end

    context "When blueberry muffin's order is present" do
      let(:params) { {'blueberry_muffin': '34'} }

      it 'returns the count of packs for blueberry muffin' do
        process_order
        
        json_body = JSON.parse(response.body)
        expect(json_body['blueberry_muffin']).not_to be_nil
      end
    end

    context "When croissant's order is present" do
      let(:params) { {'croissant': '34'} }

      it 'returns the count of packs for croissant' do
        process_order
        
        json_body = JSON.parse(response.body)
        expect(json_body['croissant']).not_to be_nil
      end
    end
  end

end
