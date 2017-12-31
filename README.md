
A simple utility to create a nice photo gallery from a folder full of images.

To build a gallery in a folder:
```
sudo docker run -it -v=SOURCE:/pictures:ro -v=DEST:/output gallery-builder
``
