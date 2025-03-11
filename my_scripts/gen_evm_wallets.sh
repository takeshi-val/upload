#!/bin/bash

# Приветственное сообщение
echo "============================="
echo " TAKESHI SCRIPTS "
echo " Этот скрипт создаст нужное вам количество EVM адресов и приватных ключей "
echo "============================="
echo ""
echo "Этот скрипт установит все зависимости и запустит генератор кошельков."
echo ""
read -p "Нажмите Enter для продолжения..."

# Обновление системы и установка необходимых пакетов
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv

# Создание и активация виртуального окружения
echo "Creating and activating virtual environment..."
python3 -m venv myenv
source myenv/bin/activate

# Обновление pip и установка eth-account
echo "Upgrading pip and installing eth-account..."
pip install --upgrade pip setuptools
pip install eth-account

# Проверка установки
echo "Verifying installation..."
python -c "from eth_account import Account; print(Account)"

# Выход из виртуального окружения
deactivate

# Создание Python-скрипта для генерации кошельков
cat <<EOF > generate_wallets.py
import os
import csv
from eth_account import Account

def print_banner():
    print("\n==============================")
    print("      Ethereum Keys")
    print("==============================\n")

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
        writer = csv.writer(file, delimiter=';')
        if not file_exists:
            writer.writerow(["Address", "Private Key"])
        for address, private_key in wallets:
            writer.writerow([address, private_key])
    
    file_path = os.path.abspath(filename)
    print(f"Кошельки добавлены в файл: {filename}")
    print(f"Полный путь: {file_path}")

def main():
    print_banner()
    count = get_wallet_count()
    wallets = generate_wallets(count)
    write_to_csv(wallets)
    print("Генерация завершена!")

if __name__ == "__main__":
    main()
EOF

# Делаем Python-скрипт исполняемым
chmod +x generate_wallets.py

# Запуск скрипта
myenv/bin/python3 generate_wallets.py

