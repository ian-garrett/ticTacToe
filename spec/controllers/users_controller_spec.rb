require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it 'returns the information about a user on a hash' do
      user_response = json_response[:user]
      expect(user_response[:username]).to eql @user.username
    end

    it { is_expected.to respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is not created' do
      before(:each) do
        @user_attributes = {
          password: 'foobarbaz'
        }
        post :create, user: @user_attributes, format: :json
      end

      it 'renders an error json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user creation was unsuccessful' do
        user_response = json_response
        expect(user_response[:errors][:username]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end

    context 'when it is successfully created' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for(:user)
        post :create, user: @user_attributes, format: :json
      end

      it 'renders the json response for the user record just created' do
        user_response = json_response[:user]
        expect(user_response[:username]).to eql @user_attributes[:username]
      end

      it { is_expected.to respond_with 201 }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, id: @user.id, user: { username: '' }
      end

      it 'renders an errors json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not updated' do
        user_response = json_response
        expect(user_response[:errors][:username]).to include "can't be blank"
      end

      it { is_expected.to respond_with 422 }
    end
    context 'when it is successfully updated' do
      before(:each) do
        patch :update, {
          id: @user.id,
          user: { username: 'johndoe' }
        }, format: :json
      end

      it 'renders the json response for the user record just updated' do
        user_response = json_response[:user]
        expect(user_response[:username]).to eql 'johndoe'
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, id: @user
    end

    it { is_expected.to respond_with 204 }
  end
end
