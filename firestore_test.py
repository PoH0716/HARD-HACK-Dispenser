from google.cloud import firestore

# Add a new document
db = firestore.Client()

for i in range(20):
  doc_ref = db.collection(u'users').document(str(i))
  doc_ref.set({
      "born": "2001", 
      "name": "George "+str(i*"I"), 
      "help": False
  })

# Then query for documents
users_ref = db.collection(u'bots')
docs = users_ref.get()

for doc in docs:
    print(u'{} => {}'.format(doc.id, doc.to_dict()))