I32 system(U8 *cmd);
I64 read(I32 fd, U8 *buf, I64 count);
I64 write(I32 fd, U8 *buf, I64 count);
I64 strlen(U8 *str);
I32 atoi(U8 *str);
U8 *strcpy(U8 *dest, U8 *src);
U8 *strcat(U8 *dest, U8 *src);

U0 print(U8 *str)
{
  write(1, str, strlen(str));
}

U0 read_line(U8 *buf, I64 max_len)
{
  I64 n = read(0, buf, max_len - 1);
  if (n > 0) {
    if (buf[n - 1] == '\n') {
      buf[n - 1] = 0;
    } else {
      buf[n] = 0;
    }
  } else {
    buf[0] = 0;
  }
}

U0 Main()
{
  I32 operation;
  I32 fs_choice;
  
  U8 name_input[256];
  U8 name[256];
  U8 image_path[512];
  U8 confirmation[256];
  U8 cmd[1024];

  system("lsblk");

  print("Enter the device name (e.g., sdb, sdc): ");
  read_line(name_input, 256);

  strcpy(name, "/dev/");
  strcat(name, name_input);

  "\nSelect operation:\n";
  "1. Format only\n";
  "2. Write image with formatting\n";
  print("Enter choice (1-2): ");
  read_line(confirmation, 256);
  operation = atoi(confirmation);

  strcpy(cmd, "umount ");
  strcat(cmd, name);
  strcat(cmd, "* 2>/dev/null");
  system(cmd);

  if (operation == 1) {
    "\nSelect file system:\n";
    "1. FAT32\n";
    "2. ext4\n";
    print("Enter choice (1-2): ");
    read_line(confirmation, 256);
    fs_choice = atoi(confirmation);

    if (fs_choice != 1 && fs_choice != 2) {
      "Invalid choice!\n";
      return;
    }

    "\nWARNING: ALL DATA ON %s WILL BE PERMANENTLY LOST!\n", name;
    print("Type 'yes' to confirm: ");
    read_line(confirmation, 256);

    if (confirmation[0] == 'y' || confirmation[0] == 'Y') {
      switch (fs_choice) {
        case 1:
          strcpy(cmd, "mkfs.fat -F32 ");
          strcat(cmd, name);
          strcat(cmd, " -I");
          system(cmd);
          "Formatted as FAT32\n";
          break;
        case 2:
          strcpy(cmd, "mkfs.ext4 ");
          strcat(cmd, name);
          system(cmd);
          "Formatted as ext4\n";
          break;
      }
      system("sync");
    } else {
      "Operation cancelled.\n";
    }
  }
  else if (operation == 2) {
    print("\nEnter the full path to image file: ");
    read_line(image_path, 512);

    "\nSelect file system for formatting before writing:\n";
    "1. FAT32\n";
    "2. ext4\n";
    print("Enter choice (1-2): ");
    read_line(confirmation, 256);
    fs_choice = atoi(confirmation);

    if (fs_choice != 1 && fs_choice != 2) {
      "Invalid choice!\n";
      return;
    }

    "\nWARNING: ALL DATA ON %s WILL BE PERMANENTLY LOST!\n", name;
    print("Type 'yes' to confirm: ");
    read_line(confirmation, 256);

    if (confirmation[0] == 'y' || confirmation[0] == 'Y') {
      "\nFormatting device...\n";
      switch (fs_choice) {
        case 1:
          strcpy(cmd, "mkfs.fat -F32 ");
          strcat(cmd, name);
          strcat(cmd, " -I");
          system(cmd);
          break;
        case 2:
          strcpy(cmd, "mkfs.ext4 ");
          strcat(cmd, name);
          system(cmd);
          break;
      }

      "\nWriting image to device...\n";
      strcpy(cmd, "dd if=");
      strcat(cmd, image_path);
      strcat(cmd, " of=");
      strcat(cmd, name);
      strcat(cmd, " bs=4M status=progress oflag=sync");
      
      "Executing: %s\n", cmd;
      system(cmd);
      
      "\nImage writing completed!\n";
      system("sync");
    } else {
      "Operation cancelled.\n";
    }
  }
  else {
    "Invalid operation choice!\n";
  }
}

Main;
