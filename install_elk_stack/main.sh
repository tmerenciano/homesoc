#!/bin/bash

# Main script to provide a menu for installing prerequisites or the ELK stack

show_menu() {
  echo "========================================="
  echo "             ELK Installation Menu       "
  echo "========================================="
  echo "1. Install Prerequisites"
  echo "2. Install ELK Stack"
  echo "3. Uninstall ELK Stack"
  echo "4. Debug ELK Stack"
  echo "5. Exit"
  echo "========================================="
}

while true; do
  # Display the menu
  show_menu

  # Read user input
  read -p "Enter your choice [1-5]: " choice

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
      echo "Uninstalling ELK"
      bash uninstall_elk.sh
      echo "ELK uninstalled successfully"
      ;;
    5)
      bash debug.sh
      ;;
    4)
      echo "Exiting the script. Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid option. Please choose between 1 and 3."
      ;;
  esac

done

