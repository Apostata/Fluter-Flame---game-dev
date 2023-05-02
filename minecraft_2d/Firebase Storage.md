# Firebase Storage

## Solving cors issues

If you already familiar with Google Cloud Services and Tools, like gcloud and/or gsutil, you can also checkout Google's documentation about CORS.

Login to your google cloud console: https://console.cloud.google.com/home. Click on "Activate Google Cloud Shell" in the upper right corner (see picture below):

Activate Google Cloud Shell

At the bottom of your window, a shell terminal will be shown, where gcloud and gsutil are already available. Execute the command shown below. It creates a json-file which is needed to setup the cors-configuration for your bucket. This configuration will allow every domain to access your bucket using XHR-Requests in the browser: echo '[{"origin": ["*"],"responseHeader": ["Content-Type"],"method": ["GET", "HEAD"],"maxAgeSeconds": 3600}]' > cors-config.json

If you want to restrict the access one or more specific domains, add their URL to the array, e.g.: echo '[{"origin": ["https://yourdomain.com", "http://localhost:*"],"responseHeader": ["Content-Type"],"method": ["GET", "HEAD"],"maxAgeSeconds": 3600}]' > cors-config.json (localhost is also added to access resources while developing, based on your needs).

Replace YOUR_BUCKET_NAME with your actual bucket name in the following command to update the cors-settings from your bucket gsutil cors set cors-config.json gs://YOUR_BUCKET_NAME

To check if everything worked as expected, you can get the cors-settings of a bucket with the following command: gsutil cors get gs://YOUR_BUCKET_NAME

You can find the bucket ID in the Storage panel of your project's Firebase Console:

Storage Panel of the Firebase Console It's the value starting with gs://.

enter image description here