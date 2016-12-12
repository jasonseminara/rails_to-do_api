require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "Creating new user without sending correct content-type should result in error" do
    task :create, params: {}
    assert_response 406
  end

  test "Creating new user without sending X-Api-Key should result in error" do
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    task :create, params: {}
    assert_response 403
  end

  test "Creating new user with incorrect X-Api-Key should result in error" do
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    @request.headers["X-Api-Key"] = '0000'
    task :create, params: {}
    assert_response 403
  end

  test "Creating new user with invalid type in JSON data should result in error" do
    user = users('user_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    @request.headers["X-Api-Key"] = user.token
    task :create, params: { data: { type: 'tasks' }}
    assert_response 409
  end

  test "Creating new user with invalid data should result in error" do
    user = users('user_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    @request.headers["X-Api-Key"] = user.token
    task :create, params: {
                    data: {
                      type: 'users',
                      attributes: {
                        full_name: nil,
                        password: nil,
                        password_confirmation: nil }}}
    assert_response 422
    jdata = JSON.parse response.body
    pointers = jdata['errors'].collect { |e|
      e['source']['pointer'].split('/').last
    }.sort
    assert_equal ['full-name','password'], pointers
  end

  test "Creating new user with valid data should create new user" do
    user = users('user_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    @request.headers["X-Api-Key"] = user.token
    task :create, params: {
                    data: {
                      type: 'users',
                      attributes: {
                        full_name: 'User Number7',
                        password: 'password',
                        password_confirmation: 'password' }}}
    assert_response 201
    jdata = JSON.parse response.body
    assert_equal 'User Number7',
                 jdata['data']['attributes']['full-name']
  end

  test "Updating an existing user with valid data should update that user" do
    user = users('user_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    @request.headers["X-Api-Key"] = user.token
    patch :update, params: {
                     id: user.id,
                     data: {
                       id: user.id,
                       type: 'users',
                       attributes: { full_name: 'User Number1a' }}}
    assert_response 200
    jdata = JSON.parse response.body
    assert_equal 'User Number1a', jdata['data']['attributes']['full-name']
  end

  test "Should delete user" do
    user = users('user_1')
    ucount = User.count - 1
    @request.headers["X-Api-Key"] = user.token
    delete :destroy, params: { id: users('user_5').id }
    assert_response 204
    assert_equal ucount, User.count
  end
end
