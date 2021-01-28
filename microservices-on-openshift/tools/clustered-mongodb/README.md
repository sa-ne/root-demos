#Assets here set up a replicating mongoDB cluster using a Kubernetes StatefulSet

See scripts for usage guide for this template.


###MongoDB Config
```
use admin
db.auth('admin','mongodb');

use test
db.createCollection("mycollection")
db.createCollection("mycollection2")


use admin
db.createUser(
			{
			  user: "testuser",
			  pwd: "testpassword",
			  roles: [
			  {role: "readWrite", db: "test"}
			  ]
			})

```