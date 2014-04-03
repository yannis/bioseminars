module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow_action :application, [:index]
      allow_action :buildings, [:index, :show]
      allow_action :categories, [:index, :show]
      allow_action :hosts, [:index, :show]
      allow_action :locations, [:index, :show]
      allow_action :sessions, [:create, :destroy]
      allow_action :seminars, [:index, :show]
    end
  end
end
