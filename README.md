# Duplicati beta image with automatic database backup

Image: `awkspace/duplicati`

This image works like [the official Duplicati image][1], but:
  * It’s built from the latest `mono` image; and
  * It automatically versions the database through `git`.

## Revert to a previous Duplicati DB version

1. Exec into the running container: `docker exec -ti duplicati /bin/bash`
2. Disable the backup job: `rm /etc/cron.hourly/duplicati-db-backup`
3. Run `duplicati-db-backup` to snapshot the current state.
4. Shut down Duplicati: `s6-svc -wD -d /run/s6/services/duplicati`
5. Use [`git-revert`][2] to revert to a known good version of the database. Or,
   if you’re not sure which version is good, start [`git-bisect`][3] to help
   track it down.
6. Run `duplicati-db-restore`.
7. Restart Duplicati: `s6-svc -wu -u /run/s6/services/duplicati`
8. Open the Duplicati web interface to confirm that everything looks good. If
   there’s a problem, return to step 4 and revert to a previous version, or
   continue running `git-bisect`.
9. Once you’ve reverted to a database version you’re satisfied with, re-enable
   the backup job: `ln -s /bin/duplicati-db-backup /etc/cron.hourly/`

[1]: https://hub.docker.com/r/duplicati/duplicati/
[2]: https://git-scm.com/docs/git-revert
[3]: https://git-scm.com/docs/git-bisect
