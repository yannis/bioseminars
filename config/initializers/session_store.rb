# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_wallet_session',
  :secret      => '7465968942176a6f7ec7af0ccc2c64357b548c439ee631a6d366a3d0d19d1bef04a95629a5d9fcd613332a2e3f16eb34d966f36a2f878a5716fc46fdf08986d5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
