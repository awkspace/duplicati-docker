# Duplicati beta image with automatic database backup

Image: `awkspace/duplicati`

This image works like [the official Duplicati image][1], but:
  * It’s built from the latest `mono` image; and
  * It contains a script to version the database using `git`.

## Revert to a previous Duplicati DB version

1. Exec into the running container: `docker exec -ti duplicati /bin/bash`
2. Shut down Duplicati: `s6-svc -wD -d /run/s6/services/duplicati`
3. Use [`git-revert`][2] to revert to a known good version of the database. Or,
   if you’re not sure which version is good, start [`git-bisect`][3] to help
   track it down.
4. Run `duplicati-db-restore`.
5. Restart Duplicati: `s6-svc -wu -u /run/s6/services/duplicati`
6. Open the Duplicati web interface to confirm that everything looks good. If
   there’s a problem, return to step 4 and revert to a previous version, or
   continue running `git-bisect`.

[1]: https://hub.docker.com/r/duplicati/duplicati/
[2]: https://git-scm.com/docs/git-revert
[3]: https://git-scm.com/docs/git-bisect
