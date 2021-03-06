
<!--#echo json="package.json" key="name" underline="=" -->
w3c-wpt-annotation-protocol-fixtures-pmb
========================================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Nicely packaged copy of
https://github.com/web-platform-tests/wpt/tree/master/annotation-protocol/files/annotations/
<!--/#echo -->



Do not confuse:
---------------

There are two very similar sets of examples:
* Those for the Annotatoion __Protocol__, which ship in this repo (see API).
* Those in the [Annotatoion __Data Model__ spec][anno-model].

  [anno-model]: https://www.w3.org/TR/annotation-model/

For details and comparison, please see
[anno-model-examples/README.md](anno-model-examples/README.md).



Motivation
----------

The original WPT repo is huge, even as "just" a zipball, and unfortunately,
GitHub still doesn't offer an easy way to download just one subdirectory.
How can we minimize download size?

* There's a somewhat-secret way to do it with SVN,
  but I don't want to install SVN just for this.
* Sparsely clone the git repo.
  Unfortunately, when I tested it, the fetch took several minutes.
  It seems like only the checkout can be sparse, not the fetch,
  so this doesn't help with the amount of data to download.
* Scrape the directory listing from the GitHub website.
  This should work. So until someone has a better idea, … it will have to do.



API
---

The module API is still experimental.
Instead, use the JSON files in the `examples/` directory.




Known issues
------------

* Needs more/better tests and docs.




&nbsp;


License
-------
<!--#echo json="package.json" key=".license" -->
BSD-3-Clause
<!--/#echo -->
