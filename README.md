# Easter contest evaluation rules

## Introduction

Every run start with:

- Restart of servers and workers
- redis-cli FLUSHALL
- redis-cli CONFIG RESETSTAT

All tests are made with siege ( brew install siege)

## Computer Setup

MacOSX 10.7, ruby 1.9.3 p125, i7 2.8GHz, 4GB ram DDR3, SSD for storage.

To avoid classical TIME_WAIT flood:

    sudo sysctl -w net.inet.ip.portrange.first=32768
    sudo sysctl -w net.inet.tcp.msl=1000
    ulimit -n 2048

OSX default:

    net.inet.ip.portrange.first: 49152 -> 32768
    net.inet.tcp.msl: 15000 -> 1000
    (ulimit -a) -n: file descriptors           256

## Host file

    127.0.0.1 localhost
    127.0.0.1 test.com
    127.0.0.1 test2.com

## Execution

All candidates have been executed through with thin server, and ruby 1.9.3 p125
(one with 1.8.7, it could not work without).

When not present Procfile has been added to start/stop service.

## Notation basics

The maximum mark is 20/20, each environment test only 1 or 2 features.

# Evaluation protocol

## Env 1 - Traffic tests (*3 points*)

    siege -f urls.txt -r 30 -c 1 -b

- Number of request: 30
- Hostnames: 
  
              "hostnames": {
                            "test2.com":
                              { "total": 15,
                                "paths": { "/":15 }
                              },
                            "test.com":
                              { "total": 15,
                                "paths": {"/test3": 3,"/test1": 9,"/test2": 3}
                              }
                            }
- "uniq_visitor": 1

## Env 2 - Track time window (*3 points*)

Restart redis

    redis-cli FLUSHALL;redis-cli CONFIG RESETSTAT;redis-cli info|grep used_memory;httperf --port=9292 --hog --server=test.com --uri=/test --wsess=600,2,1 --rate 1 --timeout 5;bundle exec ruby script/rack-top;[[ -s "script/clean" ]] && bundle exec script/clean;redis-cli info | grep used_memory;redis-cli FLUSHALL;

## Env 3 - Storage ID (*3 points*)

Customized config.ru

  siege -f urls.txt -r 30 -c 1 -b

  bundle exec ruby script/rack-top test2

- Number of request: 15
- Hostnames: "hostnames": {
                            "test2.com":
                              { "total": 15,
                                "paths": { "/":15 }
                              }
                          }
- "uniq_visitor": 1

Default livetraffic_id is suppose to only store 15 request (not 30).

Nobody got 3 points on this question.

## Env 4 - Slow request (*3 points*)

Customized config.ru

    siege -f urls.txt -r 30 -c 1 -b

    bundle exec ruby script/rack-top

- "slow_requests":[{"http://test2.com:9292/":1001},{"http://test2.com:9292/":1001},{"http://test2.com:9292/":1001},{"http://test2.com:9292/":1001},{"http://test2.com:9292/":1001},{"http://test2.com:9292/":1001},{"http://test2.com:9292/":1001},{"http://test2.com:9292/":1001},{"http://test2.com:9292/":1001},{"http://test2.com:9292/":1001}]

Due to imprecise rules at the beginning, path instead of url are accepted (rules got fixed
later).

## Env 5 - Uniq visitor (*3 points*)

Customized config.ru to get rid of favico.ico

Simple browser test, cross computer test, previous uniq_visitor count will be
taken into account.

    chrome
    http://test2.com:9292/chrome
    http://test2.com:9292/chrome
    firefox
    http://test2.com:9292/firefox
    http://test2.com:9292/firefox
    safari
    http://test.com:9292/safari
    http://test2.com:9292/safari
    external chrome
    http://test2.com:9292/chrome
    http://test2.com:9292/chrome

8 requests total expected

Expected 5 uniq visitor
4 is acceptable but not great
Previously expected 1 in case of robots

Nobody got 3 points on this question.

## Env 6 - Rate & Multi process (*3 points*)

    siege -f urls.txt -r 10000 -c 2 -b
    siege -f urls2.txt -r 10000 -c 2 -b

- Rate calculation expected: 133
- Number of requests 40k

Tolerance for average only good after 5 minutes.

## Code & solution notation (*2 points*)

4 Dimelo developers have rated anonymized solutions by order of preference. 

- 1 and 2 make 2 points
- 3 and 4 makes 1 points
- below makes no point

