#!/bin/bash

# Main script to provide a menu for installing prerequisites or the ELK stack

show_menu() {
  echo "========================================="
  echo "             ELK Installation Menu       "
  echo "========================================="
  echo "1. Install Prerequisites"
  echo "2. Install ELK Stack"
  echo "3. Exit"
  echo "========================================="
}

while true; do
  # Display the menu
  show_menu

  # Read user input
  read -p "Enter your choice [1-3]: " choice

  case $choice in
    1)
      echo "Installing prerequisites..."
      bash install_prerequisites.sh
      echo "Prerequisites installed successfully."
      ;;
    2)
      echo "Installing ELK stack..."
      bash install_elk.sh
      echo "ELK stack installation complete."
      ;;
    3)
      echo "Exiting the script. Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid option. Please choose between 1 and 3."
      ;;
  esac

done
