Here you can find source code for all scenarios in
the [Navigator-2.0-API-Usability-Research](https://github.com/flutter/uxr/wiki/Navigator-2.0-API-Usability-Research)

[Flutter Router Package Comparative Analysis](https://github.com/flutter/uxr/blob/master/nav2-usability/comparative-analysis/README.md)

[Additional scenarios](https://github.com/flutter/uxr/issues/20)

Note that, I purposely slow down the animation duration 3 times, so you can test page transition easier.

# Main scenarios (one scenario per app)

1. [Deep Linking - Path Parameters](1-deep-linking-path-parameters)
   NOTE: Currently, deep linking only works on root stack. Support for child stacks is in TODO list.
2. [Deep Linking - Query Parameters](2-deep-linking-query-parameters)
   NOTE: Currently, deep linking only works on root stack. Support for child stacks is in TODO list.
3. Login/Logout/Sign-up Routing

* [Home requires logging in](3a-authentication-home)
* Deep link

4. Nested Routing

* With tabs
* With modal dialog

5. Skipping Stacks
6. Dynamic Linking
7. Manipulation of the History Stack - Remove Duplicate Pages

# Additional scenarios (one scenario per app)

1. Nested Routing

* Remember nested route tabs
* Nested route guard

2. Sign up flow
3. Replacing a url

# TODO: All scenarios in a single app

While one scenario per app examples above can show the concepts, they could not show how it works in real apps.

An app for all scenarios example is needed to expose the pros and cons of the library.