if you use arch by the way you can download this package from AUR ( yay -S fflash )

compilation from source code:

step 1:
you need installed gcc and git package ( Gnu Complier Collection )
```
$ sudo apt install gcc git dosfstools - debian-based

$ sudo pacman -S gcc git dosfstools - arch-based
```
step 2:
download the project repository
```
$ git clone https://github.com/Nick-cpp/fflash
```
step 3:
compilation & installation

```
$ cd fflash/

$ g++ -std=c++17 fflash.cpp -o fflash

$ sudo install -Dm755 fflash /usr/bin/fflash
```
step 4:
program launch
```
$ fflash
```
