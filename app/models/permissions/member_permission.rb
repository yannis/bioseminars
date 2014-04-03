module Permissions
  class MemberPermission < BasePermission
    def initialize(user)

      allow_action :application, [:index]

      allow_action :buildings, [:index, :show, :create, :update]
      allow_action :buildings, [:destroy] do |building|
        building.locations.empty?
      end

      allow_action :categories, [:index, :show, :create, :update]
      allow_action :categories, [:destroy] do |category|
        category.seminars.empty?
      end

      allow_action :categorisations, [:create, :update, :destroy] do |categorisation|
        categorisation.seminar.user_id == user.id
      end

      allow_action :hosts, [:index, :show, :create, :update]
      allow_action :hosts, [:destroy] do |host|
        host.seminars.empty?
      end

      allow_action :hostings, [:create, :update, :destroy] do |hosting|
        hosting.seminar.user_id == user.id
      end

      allow_action :locations, [:index, :show, :create, :update]
      allow_action :locations, [:destroy] do |location|
        location.seminars.empty?
      end

      allow_action :seminars, [:index, :show, :create]
      allow_action :seminars, [:update, :destroy] do |seminar|
        seminar.user_id == user.id
      end

      # allow_action :users, [:index]
      allow_action :users, [:show, :update] do |u|
        u.id == user.id
      end

      allow_action :sessions, [:create, :destroy]

      allow_param :building, [:name]
      allow_param :category, [:name, :description, :acronym, :color]
      allow_param :host, [:name, :email]
      allow_param :location, [:name, :building_id]
      allow_param :seminar, [:title, :speaker_name, :speaker_affiliation, :start_at, :end_at, :location_id, :url, :pubmed_ids, :all_day, :hostings_attributes, :documents_attributes, :internal, :description, :categorisations, :hostings]

      allow_param :user, [:name, :email, :password, :password_confirmation]
    end
  end
end
