from google.cloud import firestore

# Add a new document
db = firestore.Client()

#response = getQuote()
#quote = response.body['

# Then query for documents
users_ref = db.collection(u'bots')
docs = users_ref.get()

for doc in docs:
    if doc.id == "2":
      doc_dict = doc.to_dict()
      requested = doc_dict['bot request']
      if requested == True:
        print("ROTATE WHEELS FORWARD")
        print("BOT ACTIVATED")
