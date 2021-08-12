---
title: "Prefer Data Constructors"
date: 2016-07-19 00:00:00 -0600
layout: post
tags: [Python, Object Oriented Programming, Functional Programming]
---

I'm no OOP expert, but I tended to write my classes a certain way. I delegated any initialization logic to the constructor. It makes sense, doesn't it? You've got some code that should run first. Why not put it in the method/function that gets called first? And so, I would trot along, happily writing code like this:

```python
class Date(object):
  def __init__(self, date_str):
    (m,d,y) = date_str.split('/')
    self.month = int(m)
    self.day   = int(d)
    self.year  = int(y)
```

It wasn't until I came across [PGPy's documentation](https://pythonhosted.org/PGPy/) that I noticed something: their code doesn't resemble your typical Python code. Take, for instance, their `PGPMessage` class:

```python
# this creates a standard message from text
# it will also be compressed, by default with ZIP DEFLATE, unless otherwise specified
text_message = pgpy.PGPMessage.new("This is a brand spankin' new message!")

# PGPMessage will automatically determine if this is a cleartext message or not
message_from_file = pgpy.PGPMessage.from_file("path/to/a/message")
message_from_blob = pgpy.PGPMessage.from_blob(msg_blob)
```

*What is this `from_blob()` stuff? Why no constructor, `PGPMessage`?*

Although I couldn't quite put my finger on it, something about this code appealed to me. After a few months, it dawned on me: PGPy's code cleanly separates behavior from data.

## Code && Data

In typical Python code--à la Python Standard Library--the arguments of a constructor or function determine the behavior of that class or function, respectively. For example, Python's `tarfile.TarFile` class can do several things, depending on how it is called:

```python
from tarfile import TarFile

# open tarball via file path
TarFile('path/to/file.tar')

# open tarball via file object
with fh:
  TarFile(fileobj=fh)
```

If I were to rewrite `PGPMessage` in this form, it might look something like this:

```python
class PGPMessage(object):
  def __init__(self, new=None, from_file=None, from_blob=None):
    if new_message is None:
      # ...
    elif from_file is None:
      # ...
    else:
      # ...

text_message = PGPMessage(new="This is a band spankin' new message!")
message_from_file = PGPMessage(from_file="path/to/a/message")
message_from_blob = PGPMessage(from_blob=msg_blob)
```

The problem with this, with conflating all of your "constructors" through the single interface of a function call, is that you mix behavior *and* data. As a result, your class will be harder to test, because every test instance of an object will execute (potentially buggy) boilerplate code as part of the constructor:

```python
# Did `is_today()` fail or did `Date()` fail? ¯\_(ツ)_/¯
def test_date_is_today():
  assert Date('7/19/2016').is_today()
```

## Code || Data

The solution is to separate your code from data. Let the class constructor--hereby referred to as the *Data Constructor*--set (and only set) the object's members. Treat the class like a `namedtuple`. And leave the initialization and all of the code that goes with it (input validation, boilerplate, pre-conditions, etc.) for the class methods, which would return an instance of the class:

```python
class Date(object):
  def __init__(self, month, day, year):
    self.month = month
    self.day   = day
    self.year  = year

  @classmethod
  def from_str(cls, date_str):
    (m,d,y) = date_str.split('/')
    return cls(m, d, y)
```

There are numerous benefits to doing so (like readability), but the one I want to focus on is the benefit to unit testing.

## Data Constructors ⇒ Better Unit Tests

Recall that a unit test is so named because it tests the smallest semantic unit of your code, arguably a function or method. It should test no more that that.

Yet, the above unit test does exactly that: it tests more than one unit, namely the method `is_today()` and the constructor, `__init__()`. By separating code from data, these unit tests will only test the appropriate unit, making debugging that much easier:

```python
# only testing `Date.is_today()`
def test_date_is_today():
  assert Date(7, 19, 2016).is_today()

# only testing `Date.from_str()`
def test_date_from_str():
  assert Date(7, 19, 2016) == Date.from_str('7/19/2016')
```

## Conclusion

Not only are data constructors better for unit testing, but they're also more readable, especially with more than one "constructor" in the constructor.

Separation of code and data is not a new concept. Nor is it exclusive to Functional Programming. Remember SQLi attacks? They've been on the tippy top of the OWASP Top Ten for 2013 *and* 2010! (And probably even longer than that). SQLi is *the* poster boy of mixing code and data.

## Updates

- As */u/k3ithk* correctly [pointed out](https://www.reddit.com/r/Python/comments/4tsl4f/prefer_data_constructors/d5k0tfj), in Python, the constructor of a class is actually `__new__()`, not `__init__()`; `__init__()` is actually the initializer. The argument is still valid. Overlook my ignorance. Just know that when I said "constructor," I meant `__init__()`.
- As */u/deltageek* pointed out, this (refactoring) is not a new concept, nor is it a Python-only concept. Another, more-popular name for this is [Factory Method](https://en.wikipedia.org/wiki/Factory_(object-oriented_programming)).
