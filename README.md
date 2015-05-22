LilyBin Slave
=============

This will be used to power [LilyBin](http://lilybin.com), a pastebin for music
based on [LilyPond](http://lilypond.org/). It is written for
[AWS Lambda](https://aws.amazon.com/lambda/) to allow for an unmatched
on-demand scalability.

How This Works
--------------

For each version of LilyPond desired, a separate Lambda function needs to be
created. The version is controlled by the `version` file in the root directory.

The workflow of this Lambda function is like this:

1.  Receive event payload from LilyBin core, in the scheme of:

    ```json
    {
      "body": "this is the LilyPond source",
      "key" : "this is the ID of the source"
    }
    ```
2.  `cd` to `/tmp`, the only writable storage.
3.  Try to install LilyPond using `install_lilypond.sh`:

    1.  Detects if `/tmp/ly` exists. If so, assume LilyPond is already
        installed, and skip to #4.
    2.  Downloads a decompressed tarball from an S3 bucket (for now
        `s3://lilybin-tarball/`).
    3.  Extracts it to `/tmp/ly`. `PATH` and `LD_LIBRARY_PATH` are modified.
    4.  The internal Ghostscript binary (`gs`) is monkey patched to avoid a
        weird error regarding Fontmaps.

4.  Write the input file to `input.ly`.
5.  Execute LilyPond on it, outputting to `rendered.pdf`, `rendered.midi`, and
    `rendered*.png`. `stderr` output is saved into a response object.
6.  Do three things concurrently (`uploadFiles`):

    1.  Upload `rendered.pdf` if it exists.
    2.  Upload `rendered.midi` if it exists.
    3.  Try to stat `rendered.png`.
        1.  If it exists, upload it to S3 as `<key>-page1.png`, and set `pages`
            property in response object to 1.
        2.  If it doesn't, count how many pages there are, and upload them as
            `<key>-page*.png`.

7.  Report that the run succeeded (or failed) with the response object.

Deployment
----------

Some deployment helpers are available in `deploy/`. These contain some details
about how my developement environment is set up so don't expect much out of
it :)

- `make-zipball.sh` makes a zipball of source files, as `code.zip`.
- `create.sh` creates a new Lambda function with the generated zipball:
  
  ```sh
  # deploy/create.sh <version>
    deploy/create.sh unstable
  ```

- `deploy.sh` updates the source of an existing Lambda function:
  
  ```sh
  # deploy/deploy.sh <version>
    deploy/deploy.sh unstable
  ```

LilyPond Tarball Generation
---------------------------

In `tools/` there are some tools for checking and updating LilyPond tarballs.

- `check-new-version.sh` checks for the latest version of stable and unstable
  LilyPond builds.
- `make-tarball.sh` downloads a LilyPond binary and decompresses it to a vanilla
  `.tar` archive.

  ```sh
  #                                 recommended; renames the tarball
  #                                 to a form fit for uploading
  # tools/make-tarball.sh <version> [<lilypad_version>]
    tools/make-tarball.sh 2.18.2-1   stable
  # --> lilypond-stable.linux-64.tar
  ```
- `upload-tarballs.sh` uploads all files matching `lilypond-*.tar` to S3.

Local and Live Tests
--------------------

`test/` contains some non-automated tests.

### Local

When you have made some local changes, `node local.js` is your friend. It
emulates the AWS Lambda API and tries to run your handler against a payload, in
`payload.json`.

You might need to `rm -rf /tmp/input.ly /tmp/rendered* /tmp/ly` if you want a
clean start.

### Live

If you have AWS CLI installed and configured properly, `test/live.sh` can be
used to test a deployed instance. You have to manually modify `func` variable
in the file to change function to test. (PR welcome)

License
-------

Copyright © 2015 Tiancheng “Timothy” Gu.

MIT licensed.

See `LICENSE.md` for the full license text.
