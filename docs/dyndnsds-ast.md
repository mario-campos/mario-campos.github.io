Title: dyndnsd's Abstract Syntax Tree
Author: Mario Campos
Date: 2017-11-28
Summary: All about how dyndnsd implements an Abstract Syntax Tree.
Tags: dyndnsd, AST, CST

For the past year, I've been quietly working on a personal project called [dyndnsd](http://www.mariocampos.io/dyndnsd). I am planning to write an introduction later, but, right now, I want to talk about a novel aspect (in my opinion) of `dyndnsd`. Here's the TL;DR: `dyndnsd` is a Dynamic DNS daemon. That is, it's purpose is to run in the background and update the *A* records of some domain, based on the current IP address of some network interface.

In order to know what domain to update and which interface to monitor, `dyndnsd` expects a configuration file. A simple configuration file might look like this:

```
user nobody
group nobody

# I am a comment
interface em0 {
  domain example.com {
    update https://...
  }
}
```

However, these bytes, as they are, are not operable (or at least not in any functional, efficient way). What I really need is a data structure that can be traversed to get the highlights. This data structure is called an [Abstract Syntax Tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) (AST). The thing about ASTs is that they are supposed to be lightweight and efficient for traversing. No frills, no superfluous details, just the bare necessities.

This is `dyndnsd`'s AST:

```C
struct ast_domain {
	char *domain;
	char *url;
};

struct ast_iface {
	char *if_name;
	size_t domain_len;
	struct ast_domain *domain[];
};

struct ast_root {
	char *user;
	char *group;
	size_t iface_len;
	struct ast_iface *iface[];
};
```

Notice that the AST only stores the key information: user name, group name, interface name, URL, etc. It has no need for comments, line numbers, keywords (like `interface`), or whitespace.

Notice anything else? How about those arrays whose size is omitted! Those, my friend, are called [Flexible Array Members](https://en.wikipedia.org/wiki/Flexible_array_member), a clever feature of C99. They are conceptually simpler and more cache-friendly than Linked Lists. And they work exactly like you imagine: when I allocate the memory for one of those `struct`s, I also include enough memory for *N* array members. The `size_t` member (such as `domain_len` or `iface_len`) is assigned the value *N*, so I know the upper bound of the array.

If that was too wordy, take a look at this UML-class diagram / memory-structure layout image:

![AST structure visualized](https://i.imgur.com/ZWiViIh.jpg)

Okay--enough with the CS. Let's take another look at that simple example. Let's see how `dyndnsd` would convert it into an AST.

![dyndnsd's AST example](https://i.imgur.com/lSu3J6L.jpg)

Don't be afraid if it looks daunting. I intentionally tried to keep it low-level. Those boxes represent "objects" in memory (or `struct`s as we refer to them C). The (arbitrary) hexadecimal number above a `struct` is its base address. The (also arbitrary) hexadecimal numbers *inside* the `struct` represent pointers--the lines just help visualize them.

One can intuit that, since all other objects "stem" from their top-left-corner object, that it must be the `struct ast_root` structure. If you squint at it carefully, you can kinda see the tree in the name Abstract Syntax Tree. The username and groupname are found at the `struct ast_root` structure because, likewise, they're in the top-level scope of the configuration file. Also, in the top-level scope of the configuration are the interface scopes. And you'll see that for each interface scope in the configuration file, there will be a corresponding pointer in the Flexible Array Member of the `struct ast_root` structure.

If you look closely, you'll see this symmetry throughout the configuration and AST. However, sometimes, there are deviations; there is some asymmetry, "shortcuts" if you will, that I've enabled, in which the configuration won't match the AST one-for-one. This is where the "Abstract" part of "Abstract Syntax Tree" comes into play. Look at the configuration below to see what I mean:

```
update https://...
interface em0 {
  domain example.com
}
```

With this configuration, you might expect to find a `char *` pointer to `"https://..."` somewhere in the `struct ast_root` structure. But you won't. Instead, this URL is "propogated" or "distributed" to the applicable domain, *example.com*. Instead, the URL will be pointed from within the applicable `struct ast_domain` structure. This allows the AST to maintain a consistent structure, regardless of where the configuration's `update` statement may lie. The benefit is that the system administrator gains some flexibility in the configuration, *and* `dyndnsd` will still have a consistent, efficient traversal path through the AST.

I've gone over the output of parsing the configuration file, but I skipped over a big part: the actual parsing. Part of the parsing phase includes this structure called the Concrete Syntax Tree (CST). My next post will cover the CST in much more detail, but, for now, I'll just leave you with a little teaser: if the AST is like Greymon or Charizard, then the CST is like Agumon or Charmander.
