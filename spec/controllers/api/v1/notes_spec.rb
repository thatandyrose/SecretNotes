describe Api::V1::NotesController do
  
  context 'retrieve note' do
    before do
      @note = FactoryGirl.create :note
    end

    context 'validating' do
      it 'should validate id' do
        get :show, {note:{password: 'secret'}}
        expect(response.status).to eq '404'
        expect(response.body).to include('Password required')
      end

      it 'should validate missing password' do  
        get :show, {note:{id: @note.id}}
        expect(response.status).to eq '404'
        expect(response.body).to include('Id required')
      end

      it 'should vaidate bad password' do
        get :show, {note:{id:@note.id, password: 'wrongsecret'}}

        expect(response.status).to eq '401'
      end
    end

    context 'show' do
      before do
        get :show, {note:{id:@note.id, password: 'secret'}}

        @note_response = JSON.parse(response.body)
      end

      it 'should return 200' do
        expect(response.status).to eq '200'
      end

      it 'should return the note with decrypted values' do
        expect(@note_response[:id]).to eq @note.id
        expect(@note_response[:title]).to eq 'some title'
        expect(@note_response[:body]).to eq 'some body'
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
        post :create, {note:{}}
      end

      it 'should give me a 404' do
        expect(response.code). to eq '404'
      end

      it 'should tell me whats wrong' do
        expect(response.body).to include('Title required')
        expect(response.body).to include('Body required')
        expect(response.body).to include('Password required')
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
        expect(@note_response[:id]).to eq Note.first.id
      end

      it 'should create a new note' do
        expect(Note.count).to eq 1
        expect(Note.first.title).to be_present
        expect(Note.first.body).to be_present
      end

      it 'should salt hash password' do
        expect(Note.first.password).to be_blank
        expect(Note.first.password_salt).to be_present
        expect(Note.first.password_hash).to be_present

        expect(Note.first.password_salt).to_not include 'secret'
        expect(Note.first.password_hash).to_not include 'secret'
      end

      it 'should encrypt note properties' do
        expect(Note.first.title).to be_blank
        expect(Note.first.body).to be_blank

        expect(Note.first.encrypted_title).to be_present
        expect(Note.first.encrypted_body).to be_present

        expect(Note.first.encrypted_title).to_not include 'my test note'
        expect(Note.first.encrypted_body).to_not include 'with some text!'
      end
    end

  end
end