# Duplicati beta image with automatic database backup

Image: `awkspace/duplicati`

This image works like [the official Duplicati image][1], but:
  * It’s built from the latest `mono` image; and
  * It automatically versions the database through `git`.

[1]: https://hub.docker.com/r/duplicati/duplicati/
