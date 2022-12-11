#!/usr/bin/python3

from __future__ import print_function
import argparse
import os
from datetime import datetime, timedelta
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from google.oauth2 import service_account


class Drive:
    def __init__(self):
        credentials = service_account.Credentials.from_service_account_file(
            "/app/" + os.environ['GOOGLE_SERVICE_ACCOUNT_JSON'], scopes=['https://www.googleapis.com/auth/drive'])

        self.service = build('drive', 'v3', credentials=credentials)

    def get_file_list(self):
        request = self.service.files().list(pageSize=1000).execute()
        return request.get('files', [])

    def get_folder_list(self):
        request = self.service.files().list(q="mimeType='application/vnd.google-apps.folder'").execute()
        return request.get('files', [])

    def delete_file(self, file_id):
        self.service.files().delete(fileId=file_id).execute()

    def delete_files(self, name):
        for file in self.get_file_list():
            if file['name'] == name:
                self.delete_file(file['id'])

    def delete_files_older_than(self, file_prefix, days):
        datetime_str = datetime.strftime(datetime.now() - timedelta(days), '%Y-%m-%d')
        file_name = file_prefix + datetime_str
        print("Delete files older than: ", datetime_str)
        for file in self.get_file_list():
            if file['name'].startswith(file_prefix) and file['name'] < file_name:
                print('Delete: ', file)
                self.delete_file(file['id'])

    def upload_file(self, file_name, file_path, mime_type, folder_id):
        body = {
            'name': file_name,
            'mimeType': mime_type,
            'parents': [folder_id]
        }
        media_body = MediaFileUpload(file_path, mimetype=mime_type)
        file = self.service.files().create(body=body, media_body=media_body).execute()
        print('Uploaded file: ', file)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Upload file.')
    parser.add_argument('--file-path', dest="file_path", type=str,
                        help='Path to the file to upload.')
    parser.add_argument('--file-name', dest="file_name", type=str,
                        help='Name of the file to upload.')
    parser.add_argument('--mime-type', dest="mime_type", type=str,
                        help='Mime type of the file to upload.')
    parser.add_argument('--upload-file', dest="upload_file", action='store_true', default=False,
                        help="Upload file.")
    parser.add_argument('--delete-files', dest="delete_files", action='store_true', default=False,
                        help="Delete all files with --file-name")
    args = parser.parse_args()

    drive = Drive()
    folders = drive.get_folder_list()
    backup_folder_id = ''
    for f in folders:
        # print(f)
        if f['name'] == 'backup':
            backup_folder_id = f['id']
            print("Backup folder: ", f)
            break

    if not backup_folder_id:
        raise(NotADirectoryError, "No folder named backup on Google Drive.")

    if args.upload_file:
        print("File name: ", args.file_name)
        print("File path: ", args.file_path)
        if not os.path.isfile(args.file_path):
            raise(FileExistsError, "File does not exist.")
        drive.upload_file(file_name=args.file_name, file_path=args.file_path, mime_type=args.mime_type,
                          folder_id=backup_folder_id)

    if args.delete_files:
        drive.delete_files(args.file_name)

    drive.delete_files_older_than('db.sqlite3_', 30)
