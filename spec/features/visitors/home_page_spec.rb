# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Home page' do

  describe 'create note' do
    before do
      visit '/'

      fill_in :note_title, with: 'some title'
      fill_in :note_body, with: 'some body'
      fill_in :note_password, with: 'some password'

      click_on 'Create note'
    end    

    it 'should create a new note' do
      expect(Note.count).to eq 1
    end
  end

  describe 'show note', js:true do
    before do
      @note = FactoryGirl.create :note
      
      visit '/'

      fill_in :id, with: @note.id
      find('#password').set('secret')

      click_on 'Show note'
    end

    it 'should return note' do
      expect(page).to have_text 'some title'
    end
    
  end

end
