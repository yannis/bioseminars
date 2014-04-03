module Permissions
  class AdminPermission < BasePermission
    def initialize(user)
      allow_all_params

      allow_action :application, [:index]

      allow_action :buildings, [:index, :show, :create]
      allow_action :buildings, :update
      allow_action :buildings, [:destroy] do |building|
        building.locations.empty?
      end

      allow_action :categories, [:index, :show, :create, :update]
      allow_action :categories, [:destroy] do |category|
        category.seminars.empty?
      end

      allow_action :categorisations, [:create, :update, :destroy]

      allow_action :documents, [:index, :show, :create, :update, :destroy]

      allow_action :hosts, [:index, :show, :create, :update]
      allow_action :hosts, [:destroy] do |host|
        host.seminars.empty?
      end

      allow_action :hostings, [:create, :update, :destroy]

      allow_action :locations, [:index, :show, :create, :update]
      allow_action :locations, [:destroy] do |location|
        location.seminars.empty?
      end

      allow_action :seminars, [:index, :show, :create, :update, :destroy]
      allow_action :sessions, [:create, :destroy]
      allow_action :users, [:index, :show, :create, :update, :destroy]
    end
  end
end
