from google.cloud import firestore

# Add a new document
db = firestore.Client()

#response = getQuote()
#quote = response.body['

# Then query for documents
users_ref = db.collection(u'bots')
docs = users_ref.get()

for doc in docs:
    print(u'{} => {}'.format(doc.id, doc.to_dict()))
