# frozen_string_literal: true

def login(user)
  @request.env['devise.mapping'] = Devise.mappings[:user]
  sign_in(user)
end
