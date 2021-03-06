<div align="center">
  <a href="https://pub.dev/packages/navi">
    <img src="https://raw.githubusercontent.com/zenonine/navi/master/assets/navi-logo-shadow.png" alt="Navi" height="150" />
  </a>

  <p>
    A simple and easy to learn declarative navigation framework for Flutter, based on Navigator 2.0 (Router).
  </p>

  <div>
    <a href="https://pub.dev/packages/navi">
      <img src="https://img.shields.io/pub/v/navi.svg" alt="pub package">
    </a>
    <a href="https://github.com/zenonine/navi/actions/workflows/verify-navi.yml">
      <img src="https://github.com/zenonine/navi/actions/workflows/verify-navi.yml/badge.svg?branch=master" alt="verify navi">
    </a>
    <a href="https://codecov.io/gh/zenonine/navi" target="_blank">
      <img src="https://codecov.io/gh/zenonine/navi/branch/master/graph/badge.svg?token=VSDR3PEJJG" alt="code coverage"/>
    </a>
  </div>
</div>

---

If you love Flutter, you would love [declarative UI](https://flutter.dev/docs/get-started/flutter-for/declarative) and
therefore **declarative navigation**.

**Navigator 2.0** provides a declarative navigation API. Unfortunately, it's **too complex and difficult to use** with a
lot of **boilerplate**. Not only that, it requires to keep a **single state** to manage the whole navigation system of
your application. It's not a good architecture, and definitely **does not fit in large scale applications**.

**Navi** helps you keep all the powerful of Navigator 2.0 but with a **simple and easy to learn API**. It helps you
manage your navigation system in **split and isolated domains**.

Note that, **imperative navigation API is also supported** as an extra layer beyond the declarative API.

* [Documentation](navi)
* [Examples](examples)
  * [Deep Linking - Path Parameters](examples/uxr/1-deep-linking-path-parameters)
  * [Deep Linking - Query Parameters](examples/uxr/2-deep-linking-query-parameters)
  * [Login/Logout/Sign-up Routing](examples/uxr/3-sign-in-routing)
  * [Skipping Stacks](examples/uxr/5-skipping-stacks)
  * [Dynamic Linking](examples/uxr/6-dynamic-linking)
  * [Nested Routing - Bottom Navigation Bar - without Keeping State](examples/bottom-navigation-bar-without-keeping-state)
  * [Nested Routing - Bottom Navigation Bar - Keeping State](examples/bottom-navigation-bar-keeping-state)
  * [Nested Routing - Tab Bar - Without Keeping State](examples/tab-bar-without-keeping-state)
  * [Nested Routing - Tab Bar - Keeping State](examples/tab-bar-keeping-state)
