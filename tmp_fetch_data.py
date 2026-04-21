import requests
import json

url = 'https://yrxhwzmwrzakozupfvwv.supabase.co/rest/v1/'
key = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlyeGh3em13cnpha296dXBmdnd2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQxMjE4ODcsImV4cCI6MjA4OTY5Nzg4N30.IfexOnwVaNqW-r82uLcU2NIZUdpvcy7vkUyBNDD_Gi4'

headers = {
    'apikey': key,
    'Authorization': f'Bearer {key}'
}

tables = ['products', 'profiles', 'orders', 'order_items', 'cart_items', 'wishlist']

for table in tables:
    print(f"\n--- {table.upper()} ---")
    try:
        r = requests.get(url + table + "?select=*&limit=3", headers=headers)
        if r.status_code == 200:
            print(json.dumps(r.json(), indent=2))
        else:
            print(f"Error {r.status_code}: {r.text}")
    except Exception as e:
        print(f"Exception: {e}")
