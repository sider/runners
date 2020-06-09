import requests

response = requests.get('https://github.com/')

print(response.status_code)
