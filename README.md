
# sqlover

Report generator for SQL.


## install

```sh
$ cd ~/w && git clone git@github.com:jmettraux/sqlover
$ chmod a+x ~/w/sqlover/src/sqlover
$ cd ~/bin && ln -s ~/w/sqlover/src/sqlover
```

## usage

```sh
$ sqlover production_log.txt
  # or
$ cat production_log.txt | sqlover
```


## license

MIT, see [LICENSE.txt](LICENSE.txt).

