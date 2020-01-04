# Goodle Assistant Action for Solar Edge Monitoring

This is an Google assistant action that pulls data from the solaredge monitoring platform
and will respond to user's voice queries with simple solar data.  

For now a good bit of the backend is hard-coded and it requires an api key and site id to
be passed via environment variables.  This means it is practically only useful as a play
thing since it will only be able to support the single API and site.  A future more flexible
version could let user's specify some custom configuration.

The server expects two environment variables to be able to run:

* **SE_API_DATA** - A JSON blob { "apiKey": "key", "siteId": Number }
* **MY_BASE_URL** - The hostname to use when returning image URLs. Specifying this makes 
  image urls absolute paths which is required for Google to render it.
  
As an alternative to specifying the `SE_API_DATA` environment variable the server will
look for an apikey.json file and load it if it is available.

## Supported Google Action Intents

* **[Default]** - When no intent is given it responds with the overview of solar production
* **More** - Responds with a solar energy produced today and a graph (if a UI is available)

## Running the service

This thing is a docker container so just build and run it per usual.

```
docker build -t solaredge .
docker run -it --env SE_API_DATA=$(cat ./apikey.json) -p 4567:4567 solaredge
```

It also supports cloudbuild which you can do via `gcloud builds submit --config cloudbuild. yaml .`
I've used this to deploy it as a cloud function for interacting with Google's DialogFlow tool.
