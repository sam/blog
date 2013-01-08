= Blog

== Setup

My database has readonly access available, so to quickly bootstrap your own blog you can download CouchDB, start the
server, open up Futon, click on Replication, set the source to `http://ssmoot.cloudant.com/blog`, and the target to
`localhost` with `blog` for the database name.

Now you can fire up the app locally with `play run`.

To deploy, just create a `conf/couchdb.properties` file to provide your own connection string:

```properties
couchdb.host=bob.cloudant.com
couchdb.username=bob
couchdb.password=s3kr3t
```

It doesn't have to be a Cloudant database of course. Any Couch 1.2 install should work fine.