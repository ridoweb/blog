---
title: Constants are Dangerous
layout: post
date: 2023-04-14
---

### What's wrong with Constants?

Using constants in your code might think like a good idea at first place, they force you to think why you need a string, and how it can be defined in a way that is _under control_, you can search for the symbol (not just random text search), allows to reduce duplication, and of course makes your code more _proffesional_, now your code is *production-ready*.

> I've found that constants do not help to achieve "Clean code that works", Why?

The first mistake is to place all constants together, just because they are constants. Then every single class requiring a string will have a dependency to that central constant location, and believe me, most of those constants are only used in one place.

I think this is a brain trap, we think that our code will be more organized if we have all strings _under control_, and if there is duplication, we can handle it just by updating the constant.

## What if?

Here is my advice, constants are used to define variables we know they are not going to change, and usually are related to a very concret feature. Everytime I have to reuse the constant in more than one place, it triggers the question: Do I have the right level of abstraction, did I get the business logic right? or how can I _centralize_ this feature in a a few classes, and make sure that is wll designed?

### Rido's rules for Constants

1. Avoid constants, they are hidden enemies of a clean design.
2. Before creating a constant -because I need that string in two methods-, try to find a refactor to make sure the string is only used in one, and only one method. Then you dont need a constant anymore.. Ok, you can declare a method constant, just to improve the memory allocation. So yes, method-level constants, are ok.. although at this point I will favor legibility over method-level duplication.
3. When you need a Constant at a class level.. is it really a constant, or something that can be descibred with an Enum?. Sometimes _class_level_constants_ are ok, but watch out what are they used for.
4. If you need a constant to be shared by multiple classes make it sure you understand the consequences. Why are those classes related? How can you desribe that relation in terms of composition, or inheritance? Maybe you are missing a class that will encapsulate the constant meaning.
5. If your reason to use constants is to enable _localization_ you are looking a bigger problem from the wrong angle. When you need to localize, the constants are the smallest problem. Localization requires a way more thoughtfull process that will never be solved with constants.

### The best metric to evaluate code quality

.. is to measure how much time it takes to understand the full code base. I'm surprised of how mich time devs spend browsing, yes browsing not reading, the code. This is one of the most expensive task for a developer team. Spend countless hours browing a code base, just because the IDE allows to "show references".

Let's take a trivial example, create a method to add quotes to a string:

```js
const quoteChar = '"'
const quote = s=> $"{quoteChar}s{quoteChar}"
```

This seems like the _right_ way to do it, and you might be tempted to move the `quoteChar` to a `Constants.js` file, so now you can control "all your variables from a single location. 

Big mistake. First, you are not going to change the constant, a quote is a quote. Second, now you can not reuse the `quote` method, since is is tight copled to `Constants.cs`, and so far.. 

So instead of having a slightly better system, is just a a much worst design, with strong coupling.

In contrast.. what wrong with this code? 

```js
const quote = s=> $"\"{s}\""
```

It's easier to understand, it has no external depdencies, so you can move it around without side effect. And believe me, you are not going to chage what a quote is.


## Modern development

Traditional develpment used to think that having "constants" in your code make your code better, easier to change, and to evolve. This is a false statment, try to find change patterns in your commit history: did you notice everytime you change your main classes, the file with constants have to be updated as well? List all the constants, and count how may are used more than once, o even more that 3 times. How many constants have changed over time?

> I've seen code where the HTTP verb 'GET' was defines as constant. Do you think there will another HTTP protocol that do not understand GET?


## Summary

Avoid constants if you can, and if you have to use them, try to use that knowledge to improve your OO design, and apply encapsulation, facades and Single Responsibily Principle.

And ever, ever create constants in a constants file.
