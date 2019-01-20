from firebase_admin import credentials
cred = credentials.Certificate('./hardhack2019-8265b-firebase-adminsdk-dozgy-51e8f4c2b6.json')
default_app= firebase_admin.initialize_app(cred)
db = firestore.client

#response = getQuote()
#quote = response.body['

for i in range(0,99):
	doc_ref = db.collection("bots").document(String(i))
	
	try:
		doc = doc_ref.get()
		print(u'Document Data: {}'.format(doc.to_dict))
	except google.cloud.exceptions.NotFound:
		print(u'No suh File found')
			
