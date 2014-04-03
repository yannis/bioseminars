require 'spec_helper'

describe BuildingSerializer do
  let(:building){create :building, id: 1, name: "flat iron"}
  let!(:location){create :location, id: 1, name: "aroom", building_id: building.id}
  let(:serializer) {BuildingSerializer.new building.reload}
  it {expect(serializer.to_json).to eql '{"building":{"id":1,"name":"flat iron","readable":true,"updatable":false,"destroyable":false,"location_ids":[1]}}'}
end
