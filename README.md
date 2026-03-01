### Build Instructions

1. Plug the Pi Pico into a USB port on a linux computer and mount it:

``` bash
dmesg | tail # find the device name, should be sda
sudo mkdir -p /mnt/pico # create directory to mount pi pico to
sudo mount /dev/sda1 /mnt/pico # ensure the pico device name is sda before doing this command
```

2. Check if Pi Pico is correctly mounted:

``` bash
ls /mnt/pico # Should see INDEX.HTM and INFO_UF2.TXT as output
```

3. From the project's root directory, create the build directory:

``` bash
mkdir build
```

4. Ensure you have the pico_sdk, follow instructions from [Pi Pico getting started docs](https://pip-assets.raspberrypi.com/categories/610-raspberry-pi-pico/documents/RP-008276-DS-1-getting-started-with-pico.pdf?disposition=inline)

5. Setup environment variable and build project:

``` bash
cd build
export PICO_SDK_PATH=../../pico_sdk
cmake ..
make
```

6. Copy executable to Pi Pico:

``` bash
sudo cp bare_metal_blink.uf2 /mnt/pico
sudo sync
```

7. Unmount Pi Pico:

``` bash
sudo umount /mnt/pico
```
