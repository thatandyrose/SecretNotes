describe Api::V1::NotesController do
  render_views

  context 'retrieve note' do

    before do
      @note = FactoryGirl.create :note
    end

    context 'validating' do
      it 'should validate id' do
        expect{ get(:show, password: 'secret') }.to raise_error(ActionController::RoutingError)
      end

      it 'should validate missing password' do  
        get :show, {id: @note.id, note:{}}
        expect(response.status).to eq 400
        expect(response.body).to include('param is missing or the value is empty: password')
      end

      it 'should vaidate bad password' do
        get :show, {id:@note.id, password: 'wrongsecret'}

        expect(response.status).to eq 400
        expect(response.body).to include('Could not authenticate')
      end
    end

    context 'show' do
      before do
        get :show, {id:@note.id, password: 'secret'}
        @note_response = JSON.parse(response.body)
      end

      it 'should return 200' do
        expect(response.status).to eq 200
      end

      it 'should return the note with decrypted values' do
        expect(@note_response['id']).to eq @note.id
        expect(@note_response['title']).to eq 'some title'
        expect(@note_response['body']).to eq 'some body'
      end

      it 'should not return password' do
        expect(@note_response.has_key?('password')).to be_falsy
        expect(@note_response.has_key?(:password)).to be_falsy
      end
    end
  end

  context 'create note' do
    
    context 'validating' do
      before do
        post :create, {note:{title: 'whatevs'}}
      end

      it 'should give me a 400' do
        expect(response.code). to eq '400'
      end
    end

    context 'create' do
      before do
        post :create, {note:{title: 'my test note', body: 'with some text!', password: 'secret'}}

        @note_response = JSON.parse(response.body)
      end

      it 'should return a 200' do
        expect(response.code). to eq '200'
      end

      it 'should return the new note' do
        expect(@note_response['id']).to eq Note.first.id
      end

      it 'should create a new note' do
        expect(Note.count).to eq 1
      end

      it 'should salt hash password' do
        expect(Note.first.password).to be_blank
        expect(Note.first.password_salt).to be_present
        expect(Note.first.password_hash).to be_present

        expect(Note.first.password_salt).to_not include 'secret'
        expect(Note.first.password_hash).to_not include 'secret'
      end

      it 'should encrypt note properties' do
        expect(Note.first.encrypted_title).to be_present
        expect(Note.first.encrypted_body).to be_present

        expect(Note.first.encrypted_title).to_not include 'my test note'
        expect(Note.first.encrypted_body).to_not include 'with some text!'
      end
    end

  end
end