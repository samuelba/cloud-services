# Bitwarden

## Google API Service Account

To backup your Bitwarden SQLite database an additional container is running. 
It backups the database and creates an encrypted archive which will be uploaded to the Google Drive. 
For this a Google Service Account is needed. The following steps explain how to create such an account.

1. Go to [Google Cloud Platform | Service Accounts](https://console.cloud.google.com/projectselector2/iam-admin/serviceaccounts?supportedpurview=project).
2. Create a new project e.g. Bitwarden

    ![New Project](images/new-project.png "New Project")

3. Create a service account

    ![Create Service Account](images/create-service-account-1.png "Create Service Account")
    
    ![Create Service Account](images/create-service-account-2.png "Create Service Account")
    
    ![Create Service Account](images/create-service-account-3.png "Create Service Account")

4. Create key (JSON), this is the key needed by the `upload.py` script
5. Share a `backup` folder from your Google Drive with the service account email address `bitwarden@example-xxx.iam.gserviceaccount.com`
