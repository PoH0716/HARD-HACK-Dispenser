import pyrebase

config = {
  "apiKey": "AIzaSyAlYyIfqY8CvVLN1Da_ZjlMU84Ag4ATB1c",
  "authDomain": "hardhack2019-8265b.firebaseapp.com",
  "databaseURL": "https://hardhack2019-8265b.firebaseio.com",
  "projectId": "hardhack2019-8265b",
  "storageBucket": "hardhack2019-8265b.appspot.com",
  "messagingSenderId": "778835641568",
  "serviceAccount": "./hardhack2019.json"
}

firebase = pyrebase.initialize_app(config)
db = firebase.database()
auth = firebase.auth()

user = {"born": "1999", "name": "Meher Akhil", "help": False}
db.child("users").push(user)