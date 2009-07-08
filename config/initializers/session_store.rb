# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hatebuta_session',
  :secret      => '3e75574553a6602dedbfc3169248c26f556800d6c9e7689691999408e22a96925b1b12dd07e5c0b54040da6259a4bccb63e0669c23900dcb46782032e9e9bad2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
