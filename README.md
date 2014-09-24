# Secretnotes

## What you need to know

- This is a Ruby on Rails application
- This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
- It requires ruby 2.1.2
- It requires rails 4.1.5
- There is one test which requires the selenium driver, so the latest version of Firefox is required.
- Data store is sqlite
- It's tested with Rspec

## Great! But what is it?

This is a simple API with two end points for CREATING and SHOWING Notes.

Creating and Showing notes requires a password. Passwords are hash salted, and the content of the notes are encrypted with the password as the encryption key.

## Interesting. So if it's an API why is there a Javascript tests?

I created a UI on the root of the app for interfacing with the API. There's some JS in there. Soz about that.

## Ahh, I see. Where's the documentation??

Glad you asked.

### Create

`post /api/v1/notes, {:password, :title, :body}`

*Required Parameters*
- :password

*Example*
`post /api/v1/notes, {password:'secret', title:'a title', body: 'a body'}`

*Response*
```
{
  "id": 13,
  "title": "a title",
  "body": "a body"
}
```

### Show

`get /api/v1/:id, {:password}`

*Required Parameters*
- :id
- :password

*Example*
`get /api/v1/notes/13, {password:'secret'}`

*Response*
```
{
  "id": 13,
  "title": "a title",
  "body": "a body"
}
```

## Hmm, ok. So how do I get this running locally

Make sure you've got all the requirements (see first section above).

```
$ bundle install
$ rake db:migrate
$ rspec
$ rails s
```

Then browse to http://localhost:3000/
