# Duplicati beta image with automatic database backup

Image: `awkspace/duplicati`

This image works like [the official Duplicati image][1], but:
  * It’s built from the latest `mono` image; and
  * It automatically versions the database through `git`.

## Revert to a previous Duplicati DB version

1. Exec into the running container: `docker exec -ti duplicati /bin/bash`
2. Run `/etc/cron.hourly/duplicati-db-backup` manually to snapshot the current
   state.
3. Shut down Duplicati: `s6-svc -wD -d /run/s6/services/duplicati`
4. Use [`git-reset`][2] to revert to a known good version of the database. If
   you’re not sure which version is good, repeating this process several times
   with [`git-bisect`][3] will help you track down the most recent bad version.
5. Run `duplicati-db-restore`.
6. Restart Duplicati: `s6-svc -wu -u /run/s6/services/duplicati`

[1]: https://hub.docker.com/r/duplicati/duplicati/
[2]: https://git-scm.com/docs/git-reset
[3]: https://git-scm.com/docs/git-bisect
