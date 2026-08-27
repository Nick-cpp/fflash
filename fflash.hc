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

  print("\nSelect operation:\n");
  print("1. Format only\n");
  print("2. Write image with formatting\n");
  print("Enter choice (1-2): ");
  read_line(confirmation, 256);
  operation = atoi(confirmation);

  strcpy(cmd, "umount ");
  strcat(cmd, name);
  strcat(cmd, "* 2>/dev/null");
  system(cmd);

  if (operation == 1) {
    print("\nSelect file system:\n");
    print("1. FAT32\n");
    print("2. ext4\n");
    print("Enter choice (1-2): ");
    read_line(confirmation, 256);
    fs_choice = atoi(confirmation);

    if (fs_choice != 1 && fs_choice != 2) {
      print("Invalid choice!\n");
      return;
    }

    print("\nWARNING: ALL DATA ON ");
    print(name);
    print(" WILL BE PERMANENTLY LOST!\nType 'yes' to confirm: ");
    read_line(confirmation, 256);

    if (confirmation[0] == 'y' || confirmation[0] == 'Y') {
      switch (fs_choice) {
        case 1:
          strcpy(cmd, "mkfs.fat -F32 ");
          strcat(cmd, name);
          strcat(cmd, " -I");
          system(cmd);
          print("Formatted as FAT32\n");
          break;
        case 2:
          strcpy(cmd, "mkfs.ext4 ");
          strcat(cmd, name);
          system(cmd);
          print("Formatted as ext4\n");
          break;
      }
      system("sync");
    } else {
      print("Operation cancelled.\n");
    }
  }
  else if (operation == 2) {
    print("\nEnter the full path to image file: ");
    read_line(image_path, 512);

    print("\nSelect file system for formatting before writing:\n");
    print("1. FAT32\n");
    print("2. ext4\n");
    print("Enter choice (1-2): ");
    read_line(confirmation, 256);
    fs_choice = atoi(confirmation);

    if (fs_choice != 1 && fs_choice != 2) {
      print("Invalid choice!\n");
      return;
    }

    print("\nWARNING: ALL DATA ON ");
    print(name);
    print(" WILL BE PERMANENTLY LOST!\nType 'yes' to confirm: ");
    read_line(confirmation, 256);

    if (confirmation[0] == 'y' || confirmation[0] == 'Y') {
      print("\nFormatting device...\n");
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

      print("\nWriting image to device...\n");
      strcpy(cmd, "dd if=");
      strcat(cmd, image_path);
      strcat(cmd, " of=");
      strcat(cmd, name);
      strcat(cmd, " bs=4M status=progress oflag=sync");
      
      print("Executing: ");
      print(cmd);
      print("\n");
      system(cmd);
      
      print("\nImage writing completed!\n");
      system("sync");
    } else {
      print("Operation cancelled.\n");
    }
  }
  else {
    print("Invalid operation choice!\n");
  }
}

Main;
