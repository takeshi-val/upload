import os
import csv
from eth_account import Account
from datetime import datetime

def print_banner():
    print("""
    =============================
          Ethereum Keys
    =============================
    """)

def get_wallet_count():
    while True:
        try:
            count = int(input("Сколько кошельков создать? "))
            if count > 0:
                return count
            else:
                print("Введите число больше 0.")
        except ValueError:
            print("Введите корректное число.")

def generate_wallets(count):
    wallets = []
    for _ in range(count):
        acct = Account.create()
        wallets.append((acct.address, acct.key.hex()))
    return wallets

def write_to_csv(wallets, filename="wallets.csv"):
    file_exists = os.path.isfile(filename)
    mode = "a" if file_exists else "w"
    
    with open(filename, mode, newline="") as file:
        writer = csv.writer(file)
        if not file_exists:
            writer.writerow(["Address", "Private Key"])
        writer.writerows(wallets)
    
    print(f"Кошельки добавлены в {filename}")

def main():
    print_banner()
    count = get_wallet_count()
    wallets = generate_wallets(count)
    write_to_csv(wallets)
    print("Генерация завершена!")

if __name__ == "__main__":
    main()
