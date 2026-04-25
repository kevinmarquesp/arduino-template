# arduino-template

Sketch template powered up with Doxygen and Google Test. It emplies that most
of **the logic should be placed in the `sketch/src/` folder** to make easier
to run tests.

This also implies that the programming style should be state oriented, where
the `sketch/src/` should only calculate and count, the `sketch/sketch.ino`
should use that logic and apply in the real world components.


# Usage

```bash
cd my-sketch
git clone https://github.com/kevinmarquesp/arduino-template .
rm -rf .git
make deps
```
